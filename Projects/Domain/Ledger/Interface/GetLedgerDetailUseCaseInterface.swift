import BaseDomain

public protocol GetLedgerDetailUseCaseInterface {
  func execute(id: Int) async throws -> LedgerDetail
}
