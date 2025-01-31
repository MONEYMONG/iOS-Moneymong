import BaseDomain

public protocol GetLedgerListUseCaseInterface {
  func excute(
    id: Int,
    start: DateInfo,
    end: DateInfo,
    page: Int,
    limit: Int,
    fundType: FundType?
  ) async throws -> LedgerList
}
