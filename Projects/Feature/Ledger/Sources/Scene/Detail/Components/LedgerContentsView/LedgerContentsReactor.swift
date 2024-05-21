import UIKit

import DesignSystem
import NetworkService
import BaseFeature

import ReactorKit

final class LedgerContentsReactor: Reactor {

  enum Action {
//    case onAppear
  }

  enum Mutation {
    case setStoreInfo(String)
    case setAmount(String)
    case setFundType(FundType)
    case setMemo(String)
    case setDate(String)
    case setTime(String)
    case setReceiptImageUrls([LedgerDetail.ImageURL])
    case setDocumentImageUrls([LedgerDetail.ImageURL])
    case setAuthorName(String)
  }

  struct State {
    let prevLedgerItem: LedgerDetailItem?
    @Pulse var storeInfo: String?
    @Pulse var amount: String?
    @Pulse var fundType: FundType?
    @Pulse var memo: String?
    @Pulse var date: String?
    @Pulse var time: String?
    @Pulse var receiptImageUrls: [LedgerDetail.ImageURL]?
    @Pulse var documentImageUrls: [LedgerDetail.ImageURL]?
    @Pulse var authorName: String?
  }

  var initialState: State
  private let formatter = ContentFormatter()

  init(ledger: LedgerDetail?) {
    guard let ledger else {
      self.initialState = State(prevLedgerItem: nil)
      return
    }

    let (date, time) = self.formatter.convertToDateTime(with: ledger.paymentDate)
    let item = LedgerDetailItem.init(
      storeInfo: ledger.storeInfo,
      amount: self.formatter.convertToAmount(with: ledger.amount) ?? "0",
      fundType: ledger.fundType,
      memo: ledger.description,
      date: date,
      time: time,
      receiptImageUrls: ledger.receiptImageUrls,
      documentImageUrls: ledger.documentImageUrls,
      authorName: ledger.authorName
    )

    self.initialState = State(
      prevLedgerItem: item,
      storeInfo: item.storeInfo,
      amount: item.amount,
      fundType: item.fundType,
      memo: item.memo,
      date: item.date,
      time: item.time,
      receiptImageUrls: item.receiptImageUrls,
      documentImageUrls: item.documentImageUrls,
      authorName: item.authorName
    )
  }

  func mutate(action: Action) -> Observable<Mutation> {
//    switch action {
//    case .onAppear:
//
//    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setStoreInfo(let storeInfo):
      newState.storeInfo = storeInfo
    case .setAmount(let amount):
      newState.amount = amount
    case .setFundType(let fundType):
      newState.fundType = fundType
    case .setMemo(let memo):
      newState.memo = memo
    case .setDate(let date):
      newState.date = date
    case .setTime(let time):
      newState.time = time
    case .setReceiptImageUrls(let urls):
      newState.receiptImageUrls = urls
    case .setDocumentImageUrls(let urls):
      newState.documentImageUrls = urls
    case .setAuthorName(let authorName):
      newState.authorName = authorName
    }
    return newState
  }
}
