import LedgerInterface
import BaseDomain

public struct MockGetLedgerListUseCase: GetLedgerListUseCaseInterface {
  public init() {}
  
  public func execute(id: Int, start: DateInfo, end: DateInfo, page: Int, limit: Int, fundType: FundType?) async throws -> LedgerList {
    return LedgerList(
      totalBalance: 0,
      totalCount: 5,
      ledgers: [
        .init(id: 0, storeInfo: "Test0", fundType: .expense, amount: 0, balance: 100, order: 0, paymentDate: "2023-11-16T15:36:11"),
        .init(id: 1, storeInfo: "Test1", fundType: .income, amount: 0, balance: 100, order: 1, paymentDate: "2023-11-16T15:36:11"),
        .init(id: 2, storeInfo: "Test2", fundType: .expense, amount: 0, balance: 100, order: 2, paymentDate: "2023-11-16T15:36:11"),
        .init(id: 3, storeInfo: "Test3", fundType: .income, amount: 0, balance: 100, order: 3, paymentDate: "2023-11-16T15:36:11"),
        .init(id: 4, storeInfo: "Test4", fundType: .expense, amount: 0, balance: 100, order: 4, paymentDate: "2023-11-16T15:36:11")
      ]
    )
  }
}
