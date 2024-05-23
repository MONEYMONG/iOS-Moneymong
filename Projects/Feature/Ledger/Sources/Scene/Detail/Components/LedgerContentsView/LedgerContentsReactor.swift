import UIKit

import DesignSystem
import NetworkService
import BaseFeature

import ReactorKit

final class LedgerContentsReactor: Reactor {
  enum ValueType {
    case storeInfo(String)
    case amount(String)
    case fundType(FundType)
    case memo(String)
    case date(String)
    case time(String)
    //    case rece
    case authorName(String)
  }

  enum Action {
    case didValueChanged(ValueType)
  }

  enum Mutation {
    case setValueChanged(ValueType)
    //    case setStoreInfo(String)
    //    case setAmount(String)
    //    case setFundType(FundType)
    //    case setMemo(String)
    //    case setDate(String)
    //    case setTime(String)
    //    case setReceiptImageUrls([LedgerImageSectionModel.Model])
    //    case setDocumentImageUrls([LedgerImageSectionModel.Model])
    //    case setAuthorName(String)
  }

  struct State {
    let prevLedgerItem: LedgerDetailItem?
    @Pulse var currentLedgerItem: LedgerDetailItem
    //    @Pulse var storeInfo: String?
    //    @Pulse var amount: String?
    //    @Pulse var fundType: FundType?
    //    @Pulse var memo: String?
    //    @Pulse var date: String?
    //    @Pulse var time: String?
    //    @Pulse var receiptImages: [LedgerImageSectionModel.Model]?
    //    @Pulse var documentImages: [LedgerImageSectionModel.Model]?
    //    @Pulse var authorName: String?
  }

  var initialState: State
  private let ledgerService: LedgerServiceInterface

  init(ledgerService: LedgerServiceInterface, ledger: LedgerDetail?) {
    self.ledgerService = ledgerService

    self.initialState = State(
      prevLedgerItem: LedgerDetailItem(ledger: ledger, formatter: ContentFormatter()),
      currentLedgerItem: LedgerDetailItem(ledger: ledger, formatter: ContentFormatter())
    )
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didValueChanged(let valueType):
      return .just(.setValueChanged(valueType))
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
        }
        let isChanged = currentState.currentLedgerItem == currentState.prevLedgerItem
        ledgerService.ledgerContents.didValueChanged(isChanged)

        return newState
      }
    }
  }
}
