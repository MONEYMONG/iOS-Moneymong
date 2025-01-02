import Foundation

public protocol GetLedgerDetailUseCaseInterface {
  func execute(id: Int) async throws -> LedgerDetail
}
