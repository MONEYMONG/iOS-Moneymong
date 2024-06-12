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
    var prevLedgerItem: LedgerDetailItem = .empty
    @Pulse var currentLedgerItem: LedgerDetailItem = .empty
    @Pulse var selectedSection: ImageSection?
    @Pulse var error: MoneyMongError?
    @Pulse var state: LedgerContentsView.State = .read
  }

  var initialState = State()
  let formatter: ContentFormatter
  private let ledgerContentsService: LedgerDetailContentsServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface

  init(
    ledgerContentsService: LedgerDetailContentsServiceInterface,
    ledgerRepo: LedgerRepositoryInterface,
    formatter: ContentFormatter
  ) {
    self.ledgerContentsService = ledgerContentsService
    self.ledgerRepo = ledgerRepo
    self.formatter = formatter
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
              ledgerContentsService.setIsLoading(true)
              let ledger = try await ledgerRepo.update(ledger: currentState.currentLedgerItem.toEntity)
              ledgerContentsService.setIsLoading(false)
              return ledger
            }
            .map { .setLedger(.init(ledger: $0)) }
              .catch { [weak self] error in
                self?.ledgerContentsService.setIsLoading(false)
                return .just(.setError(error.toMMError))
              },

          .just(.setState(state))
        ])
        // 변경사항이 없는경우
      } else {
        return .just(.setState(state))
      }

    case .didValueChanged(let valueType):
      let convertedFormValue = setContentValueFormat(valueType)
      let isValid = checkContent(valueType)
      ledgerContentsService.didValidChanged(isValid)
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
        .catch { [weak self] error in
          self?.ledgerContentsService.setIsLoading(false)
          return .just(.setError(error.toMMError))
        }

    case .deleteImage(let item):
      switch item.imageSection {
      case .receipt:
        return .just(.setValueChanged(.receiptImage(item, false)))
      case .document:
        return .just(.setValueChanged(.documentImage(item, false)))
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setValueChanged(let valueType):
      switch valueType {

      case .storeInfo(let storeInfo):
        newState.currentLedgerItem.storeInfo = storeInfo

      case .amount(let amount):
        newState.currentLedgerItem.amount = amount

      case .fundType(let fundType):
        newState.currentLedgerItem.fundType = fundType

      case .memo(let memo):
        newState.currentLedgerItem.memo = memo

      case .date(let date):
        newState.currentLedgerItem.date = date

      case .time(let time):
        newState.currentLedgerItem.time = time

      case .authorName(let authorName):
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
    if currentState.currentLedgerItem.addedDocumentImages.count > 0 {
      let id = currentState.currentLedgerItem.id
      let urls = currentState.currentLedgerItem.addedReceiptImages.map { $0.url }
      try await ledgerRepo.documentImagesUpload(detailId: id, documentImageUrls: urls)
    }
  }

  func deleteReceiptImages() async throws {
      let id = currentState.currentLedgerItem.id
      for imageInfo in currentState.currentLedgerItem.deletedReceiptImages {
          try await ledgerRepo.receiptImageDelete(
            detailId: id,
            receiptId: Int(imageInfo.key) ?? 0
          )
      }
  }

  func deleteDocumentImages() async throws {
      let id = currentState.currentLedgerItem.id
      for imageInfo in currentState.currentLedgerItem.deletedDocumentImages {
          try await ledgerRepo.documentImageDelete(
            detailId: id,
            documentId: Int(imageInfo.key) ?? 0
          )
      }
  }

  func checkContent(_ content: ContentType) -> Bool {
    switch content {
    case .storeInfo(let v):
      return (1...20) ~= v.count

    case .amount(let v):
      guard v.isEmpty == false,
            let amount = Int(v.replacingOccurrences(of: ",", with: "")),
            amount <= 999_999_999
      else {
        return false
      }
      return true

    case .date(let v):
      let pattern = "^\\d{4}.(0[1-9]|1[012]).(0[1-9]|[12]\\d|3[01])$"
      let regex = try! NSRegularExpression(pattern: pattern)
      let result = regex.firstMatch(
        in: v,
        range: NSRange(location: 0, length: v.count)
      )
      return result != nil

    case .time(let v):
      let pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$"
      let regex = try! NSRegularExpression(pattern: pattern)
      let result = regex.firstMatch(
        in: v,
        range: NSRange(location: 0, length: v.count)
      )
      return result != nil

    case .memo(let v):
      return (1...300) ~= v.count

    default:
      return true
    }
  }

  func setContentValueFormat(_ type: ContentType) -> ContentType {
    switch type {
    case .storeInfo(let value):
      return .storeInfo(value)
    case .amount(let value):
      return .amount(formatter.convertToAmount(with: value) ?? "")
    case .date(let value):
      return .date(formatter.convertToDate(with: value, separator: "."))
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
