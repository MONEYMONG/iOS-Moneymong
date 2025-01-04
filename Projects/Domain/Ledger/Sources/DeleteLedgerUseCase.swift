import Foundation

import Core
import LedgerInterface

public struct DeleteLedgerUseCase: DeleteLedgerUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(id: Int) async throws {
    try await ledgerRepo.delete(id: id)
  }
}
