import UIKit

import DesignSystem
import NetworkService
import BaseFeature

import ReactorKit

final class LedgerContentsReactor: Reactor {

  enum ContentType {
    case storeInfo(String)
    case amount(String)
    case fundType(FundType)
    case memo(String)
    case date(String)
    case time(String)
    case authorName(String)
    case receiptImage(LedgerImageInfo, Bool)
    case documentImage(LedgerImageInfo, Bool)
  }

  enum ImageSection {
    case receipt
    case document
  }

  enum Action {
    case didStateChanged(LedgerContentsView.State)
    case didValueChanged(ContentType)
    case selectedImageSection(ImageSection)
    case selectedImage(Data)
    case deleteImage(LedgerImageInfo)
    case registrationLedger(LedgerDetail)
  }

  enum Mutation {
    case setLedger(LedgerDetailItem)
    case setValueChanged(ContentType)
    case setSelectedImageSection(ImageSection)
    case setState(LedgerContentsView.State)
    case setError(MoneyMongError)
  }

  struct State {
    var addedReceiptImageUrls: [ImageInfo] = []
    var deletedReceiptImageUrls: [ImageInfo] = []

    var prevLedgerItem: LedgerDetailItem = .empty
    @Pulse var currentLedgerItem: LedgerDetailItem = .empty
    @Pulse var selectedSection: ImageSection?
    @Pulse var error: MoneyMongError?
    @Pulse var state: LedgerContentsView.State = .read
  }

  var initialState = State()
  private let formatter = ContentFormatter()
  private let ledgerContentsService: LedgerDetailContentsServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface

  init(
    ledgerContentsService: LedgerDetailContentsServiceInterface,
    ledgerRepo: LedgerRepositoryInterface
  ) {
    self.ledgerContentsService = ledgerContentsService
    self.ledgerRepo = ledgerRepo
  }

  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(action, serviceAction)
  }

  private var serviceAction: Observable<Action> {
    return ledgerContentsService.parentViewEvent
      .withUnretained(self)
      .flatMap { owner, action -> Observable<Action> in
        switch action {
        case .shouldTypeChanged(let state):
          return .just(.didStateChanged(state))
        case .setLedger(let ledger):
          return .just(.registrationLedger(ledger))
        }
      }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .registrationLedger(let ledger):
      return .just(.setLedger(.init(ledger: ledger)))

    case .didStateChanged(let state):
      // 변경사항이 있는경우
      if currentState.currentLedgerItem != currentState.prevLedgerItem {
        return .concat([
            .task {
              try await registrationReceiptImages() // 영수증 이미지 업로드된게 있을경우 해당 장부에 이미지 등록
              try await registrationDocumentImages() // 증빙자료 이미지 업로드된게 있을경우 해당 장부에 이미지 등록
              try await deleteReceiptImages() // 영수증 이미지 제거해야할게 있을경우 해당 장부에서 제거
              try await deleteDocumentImages() // 증빙자료 이미지 제거해야할게 있을경우 해당 장부에서 제거

              // 이미지를 제외한 내용 수정
              let ledger = try await ledgerRepo.update(ledger: currentState.currentLedgerItem.toEntity)
              ledgerContentsService.setIsLoading(false)
              return ledger
            }
            .map { .setLedger(.init(ledger: $0)) }
            .catch { .just(.setError($0.toMMError)) },

          .just(.setState(state))
        ])
        // 변경사항이 없는경우
      } else {
        return .just(.setState(state))
      }

    case .didValueChanged(let valueType):
      let convertedFormValue = setContentValueFormat(valueType)
      return .just(.setValueChanged(convertedFormValue))

    case .selectedImageSection(let section):
      return .just(.setSelectedImageSection(section))

    case .selectedImage(let data):
      return .task { return try await ledgerRepo.imageUpload(data) }
        .map { [weak self] imageInfo in
          let selectedSection = self?.currentState.selectedSection ?? .receipt
          switch selectedSection {
          case .receipt:
            return .setValueChanged(
              .receiptImage(.init(imageSection: .receipt, key: imageInfo.key, url: imageInfo.url), true)
            )
          case .document:
            return .setValueChanged(
              .documentImage(.init(imageSection: .document, key: imageInfo.key, url: imageInfo.url), true)
            )
          }
        }
        .catch { .just(.setError($0.toMMError)) }

    case .deleteImage(let item):
      return .task { try await ledgerRepo.imageDelete(item.toEntity) }
        .map {
          switch item.imageSection {
          case .receipt:
            return .setValueChanged(.receiptImage(item, false))
          case .document:
            return .setValueChanged(.documentImage(item, false))
          }
        }
        .catch { .just(.setError($0.toMMError)) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setValueChanged(let valueType):
      switch valueType {

      case .storeInfo(let storeInfo):
        ledgerContentsService.didValidChanged(!storeInfo.isEmpty)
        newState.currentLedgerItem.storeInfo = storeInfo

      case .amount(let amount):
        ledgerContentsService.didValidChanged(!amount.isEmpty)
        newState.currentLedgerItem.amount = amount

      case .fundType(let fundType):
        newState.currentLedgerItem.fundType = fundType

      case .memo(let memo):
        newState.currentLedgerItem.memo = memo

      case .date(let date):
        ledgerContentsService.didValidChanged(!date.isEmpty)
        newState.currentLedgerItem.date = date

      case .time(let time):
        ledgerContentsService.didValidChanged(!time.isEmpty)
        newState.currentLedgerItem.time = time

      case .authorName(let authorName):
        ledgerContentsService.didValidChanged(!authorName.isEmpty)
        newState.currentLedgerItem.authorName = authorName

      case .receiptImage(let imageInfo, let isAdd):
        if isAdd {
          newState.currentLedgerItem.addImageItem(section: .receipt, imageInfo: imageInfo)
        } else {
          newState.currentLedgerItem.deleteImageItem(section: .receipt, imageInfo: imageInfo)
        }

      case .documentImage(let imageInfo, let isAdd):
        if isAdd {
          newState.currentLedgerItem.addImageItem(section: .document, imageInfo: imageInfo)
        } else {
          newState.currentLedgerItem.deleteImageItem(section: .document, imageInfo: imageInfo)
        }
      }

    case .setSelectedImageSection(let section):
      newState.selectedSection = section

    case .setError(let error):
      newState.error = error

    case .setState(let state):
      switch state {
      case .read: newState.currentLedgerItem.setRead()
      case .update: newState.currentLedgerItem.setUpdate()
      }
      newState.state = state
      
    case .setLedger(let ledger):
      newState.prevLedgerItem = ledger
      newState.currentLedgerItem = ledger
    }

    return newState
  }
}

fileprivate extension LedgerContentsReactor {
  func registrationReceiptImages() async throws {
    if currentState.currentLedgerItem.addedReceiptImages.count > 0 {
      let id = currentState.currentLedgerItem.id
      let urls = currentState.currentLedgerItem.addedReceiptImages.map { $0.url }
      try await ledgerRepo.receiptImagesUpload(detailId: id, receiptImageUrls: urls)
    }
  }

  func registrationDocumentImages() async throws {
    if currentState.currentLedgerItem.addedReceiptImages.count > 0 {
      let id = currentState.currentLedgerItem.id
      let urls = currentState.currentLedgerItem.addedReceiptImages.map { $0.url }
      try await ledgerRepo.receiptImagesUpload(detailId: id, receiptImageUrls: urls)
    }
  }

  func deleteReceiptImages() async throws {
      let id = currentState.currentLedgerItem.id
      for imageInfo in currentState.currentLedgerItem.deletedReceiptImages {
          try await ledgerRepo.receiptImageDelete(detailId: id, receiptId: Int(imageInfo.key) ?? 0)
      }
  }

  func deleteDocumentImages() async throws {
      let id = currentState.currentLedgerItem.id
      for imageInfo in currentState.currentLedgerItem.deletedDocumentImages {
          try await ledgerRepo.receiptImageDelete(detailId: id, receiptId: Int(imageInfo.key) ?? 0)
      }
  }

  func setContentValueFormat(_ type: ContentType) -> ContentType {
    switch type {
    case .storeInfo(let value):
      return .storeInfo(value)
    case .amount(let value):
      return .amount(formatter.convertToAmount(with: value) ?? "")
    case .date(let value):
      return .date(formatter.convertToDate(with: value))
    case .time(let value):
      return .time(formatter.convertToTime(with: value))
    case .memo(let value):
      return .memo(value)
    case .fundType(let value):
      return .fundType(value)
    case .authorName(let value):
      return .authorName(value)
    case .receiptImage(let imageInfo, let isAdd):
      return.receiptImage(imageInfo, isAdd)
    case .documentImage(let imageInfo, let isAdd):
      return .documentImage(imageInfo, isAdd)
    }
  }
}
