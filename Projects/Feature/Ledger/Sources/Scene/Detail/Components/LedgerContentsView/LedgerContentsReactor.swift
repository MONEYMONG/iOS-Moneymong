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
    case didTypeChanged(LedgerContentsView.State)
    case didValueChanged(ContentType)
    case selectedImageSection(ImageSection)
    case selectedImage(Data)
    case deleteImage(LedgerImageInfo)
  }

  enum Mutation {
    case setLedger(LedgerDetailItem)
    case setValueChanged(ContentType)
    case setSelectedImageSection(ImageSection)
    case setState(LedgerContentsView.State)
    case setError(MoneyMongError)
    case setIsLoading(Bool)
  }

  struct State {
    var prevLedgerItem: LedgerDetailItem
    @Pulse var currentLedgerItem: LedgerDetailItem
    @Pulse var selectedSection: ImageSection?
    @Pulse var error: MoneyMongError?
    @Pulse var state: LedgerContentsView.State
    @Pulse var isLoading: Bool?
  }

  var initialState: State
  private let formatter = ContentFormatter()
  private let ledgerDetailService: LedgerDetailContentsServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface

  init(
    ledgerDetailService: LedgerDetailContentsServiceInterface,
    ledgerRepo: LedgerRepositoryInterface,
    ledger: LedgerDetail?,
    state: LedgerContentsView.State = .read
  ) {
    self.ledgerDetailService = ledgerDetailService
    self.ledgerRepo = ledgerRepo
    self.initialState = State(
      prevLedgerItem: LedgerDetailItem(ledger: ledger, formatter: formatter),
      currentLedgerItem: LedgerDetailItem(ledger: ledger, formatter: formatter),
      state: state
    )
  }

  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(action, serviceAction)
  }

  private var serviceAction: Observable<Action> {
    return ledgerDetailService.parentViewEvent
      .withUnretained(self)
      .flatMap { owner, action -> Observable<Action> in
        switch action {
        case .shouldTypeChanged(let state):
          return .just(.didTypeChanged(state))
        }
      }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .didTypeChanged(let state):
      // 변경사항이 있는경우
      if currentState.currentLedgerItem != currentState.prevLedgerItem {
        return .concat([
          .just(.setIsLoading(true)),

          .task { return try await ledgerRepo.update(ledger: currentState.currentLedgerItem.toEntity) }
            .map { .setLedger(.init(ledger: $0, formatter: self.formatter)) }
            .catch { .just(.setError($0.toMMError)) },

          .just(.setIsLoading(false)),

          .just(.setState(state))
        ])
      } else {
        return .just(.setState(state))
      }

    case .didValueChanged(let valueType):
      let convertedFormValue = setContentValueFormat(valueType)
      return .just(.setValueChanged(convertedFormValue))

    case .selectedImageSection(let section):
      return .just(.setSelectedImageSection(section))

    case .selectedImage(let data):
      return .task {
        let imageInfo = try await ledgerRepo.imageUpload(data)
        let selectedSection = currentState.selectedSection ?? .receipt
        switch selectedSection {
        case .receipt: 
          try await ledgerRepo.receiptImagesUpload(
            detailId: currentState.currentLedgerItem.id,
            receiptImageUrls: [imageInfo.url]
          )
        case .document: try await ledgerRepo.documentImagesUpload(
          detailId: currentState.currentLedgerItem.id,
          documentImageUrls: [imageInfo.url]
        )
        }
        return imageInfo
      }
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
      return .task {
        switch item.imageSection {
        case .receipt:
          try await ledgerRepo.receiptImageDelete(
            detailId: currentState.currentLedgerItem.id,
            receiptId: Int(item.key) ?? 0)
        case .document:
          try await ledgerRepo.documentImageDelete(
            detailId: currentState.currentLedgerItem.id,
            documentId: Int(item.key) ?? 0)
        }
      }
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
        ledgerDetailService.didValidChanged(!storeInfo.isEmpty)
        newState.currentLedgerItem.storeInfo = storeInfo

      case .amount(let amount):
        ledgerDetailService.didValidChanged(!amount.isEmpty)
        newState.currentLedgerItem.amount = amount

      case .fundType(let fundType):
        newState.currentLedgerItem.fundType = fundType

      case .memo(let memo):
        newState.currentLedgerItem.memo = memo

      case .date(let date):
        ledgerDetailService.didValidChanged(!date.isEmpty)
        newState.currentLedgerItem.date = date

      case .time(let time):
        ledgerDetailService.didValidChanged(!time.isEmpty)
        newState.currentLedgerItem.time = time

      case .authorName(let authorName):
        ledgerDetailService.didValidChanged(!authorName.isEmpty)
        newState.currentLedgerItem.authorName = authorName

      case .receiptImage(let imageInfo, let isAdd):
        let prevItems = newState.currentLedgerItem.receiptImages.items
        let imageItems = prevItems.filter {
          guard case .imageAddButton = $0 else { return true }
          return false
        }

        if isAdd {
          if prevItems.count == 13 {
            newState.currentLedgerItem.receiptImages.items = imageItems
          } else {
            newState.currentLedgerItem.receiptImages.items = prevItems + [.image(imageInfo)]
          }
        } else {
          let filteredItem = prevItems.filter {
            guard case .image(let info) = $0 else { return false }
            return info.key != imageInfo.key ? true : false
          }
          if prevItems.count == 12 {
            newState.currentLedgerItem.receiptImages.items = [.imageAddButton] + filteredItem
          } else {
            newState.currentLedgerItem.receiptImages.items = filteredItem
          }
        }

      case .documentImage(let imageInfo, let isAdd):
        let prevItems = newState.currentLedgerItem.documentImages.items
        let imageItems = prevItems.filter {
          guard case .imageAddButton = $0 else { return true }
          return false
        }

        if isAdd {
          if prevItems.count == 13 {
            newState.currentLedgerItem.documentImages.items = imageItems
          } else {
            newState.currentLedgerItem.documentImages.items = prevItems + [.image(imageInfo)]
          }
        } else {
          let filteredItem = prevItems.filter {
            guard case .image(let info) = $0 else { return false }
            return info.key != imageInfo.key ? true : false
          }
          if prevItems.count == 12 {
            newState.currentLedgerItem.documentImages.items = [.imageAddButton] + filteredItem
          } else {
            newState.currentLedgerItem.documentImages.items = filteredItem
          }
        }
      }

    case .setSelectedImageSection(let section):
      newState.selectedSection = section

    case .setError(let error):
      newState.error = error

    case .setState(let state):
      newState.currentLedgerItem.receiptImages.items = setImageItems(to: state, section: .receipt)
      newState.currentLedgerItem.documentImages.items = setImageItems(to: state, section: .document)
      newState.state = state

    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    case .setLedger(let ledger):
      newState.prevLedgerItem = ledger
      newState.currentLedgerItem = ledger
    }

    return newState
  }
}

fileprivate extension LedgerContentsReactor {
  func setImageItems(
    to state: LedgerContentsView.State,
    section: ImageSection
  ) -> [LedgerImageSectionModel.Item] {
    var items: [LedgerImageSectionModel.Item] = []

    switch section {
    case .receipt:
      let receiptItems = currentState.currentLedgerItem.receiptImages.items

      /// State Read
      if state == .read {
        let imageItems = receiptItems.filter {
          guard case .imageAddButton = $0 else { return true }
          return false
        }
        items = imageItems.isEmpty ? [.description("내용없음")] : imageItems
      }

      /// State Update
      if state == .update {
        let imageItems = receiptItems.filter {
          guard case .description = $0 else { return true }
          return false
        }
        if currentState.currentLedgerItem.receiptImages.items.count != 12 {
          items = [.imageAddButton] + imageItems
        } else {
          items = imageItems
        }
      }

    case .document:
      let documentItems = currentState.currentLedgerItem.documentImages.items

      /// State Read
      if state == .read {
        let imageItems = documentItems.filter {
          guard case .imageAddButton = $0 else { return true }
          return false
        }

        items = imageItems.isEmpty ? [.description("내용없음")] : imageItems
      }

      /// State Update
      if state == .update {
        let imageItems = documentItems.filter {
          guard case .description = $0 else { return true }
          return false
        }
        if currentState.currentLedgerItem.documentImages.items.count != 12 {
          items = [.imageAddButton] + imageItems
        } else {
          items = imageItems
        }
      }
    }
    return items
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

  //  func checkContent(_ content: Content, type: ContentType) -> Bool? {
  //    var pattern: String!
  //    var value: String!
  //    switch type {
  //    case .source:
  //      if content.source.isEmpty { return nil }
  //      return content.source.count <= 20
  //    case .amount:
  //      if content.amount.isEmpty { return nil }
  //      return Int(content.amount.replacingOccurrences(of: ",", with: ""))! <= 999999999
  //    case .fundType:
  //      return content.amountSign == 1 || content.amountSign == 0
  //    case .date:
  //      pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
  //      value = content.date
  //    case .time:
  //      pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"
  //      value = content.time
  //    case .memo:
  //      if content.memo.isEmpty { return nil }
  //      return content.memo.count <= 300
  //    }
  //
  //    let regex = try! NSRegularExpression(pattern: pattern)
  //    let result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))
  //
  //    return result != nil
  //  }
}
