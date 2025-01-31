import Foundation

public struct LedgerList: Equatable {
  public let totalBalance: Int
  public let totalCount: Int
  public let ledgers: [Ledger]
  
  public init(totalBalance: Int, totalCount: Int, ledgers: [Ledger]) {
    self.totalBalance = totalBalance
    self.totalCount = totalCount
    self.ledgers = ledgers
  }
}
