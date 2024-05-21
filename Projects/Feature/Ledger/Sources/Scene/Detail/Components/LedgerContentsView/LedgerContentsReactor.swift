import UIKit

import DesignSystem
import NetworkService
import BaseFeature

import ReactorKit

final class LedgerContentsReactor: Reactor {

  enum Action {

  }

  enum Mutation {

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
      id: ledger.id,
      storeInfo: ledger.storeInfo,
      amountText: self.formatter.convertToAmount(with: ledger.amount) ?? "0",
      fundType: ledger.fundType,
      memo: ledger.description,
      paymentDate: date,
      paymentTime: time,
      receiptImageUrls: ledger.receiptImageUrls,
      documentImageUrls: ledger.documentImageUrls,
      authorName: ledger.authorName
    )
    self.initialState = State(prevLedgerItem: item)
  }
}
