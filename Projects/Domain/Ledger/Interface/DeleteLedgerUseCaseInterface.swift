import Foundation

public protocol DeleteLedgerUseCaseInterface {
  func execute(id: Int) async throws
}
