import BaseDomain

public protocol UpdateLedgerUseCaseInterface {
  func execute(request: LedgerDetail) async throws -> LedgerDetail
}
