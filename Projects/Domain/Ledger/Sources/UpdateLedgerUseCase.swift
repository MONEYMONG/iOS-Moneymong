import Foundation

import Core
import LedgerInterface

public struct UpdateLedgerUseCase: UpdateLedgerUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(request: LedgerDetail) async throws -> LedgerDetail {
    return try await ledgerRepo.update(ledger: request)
  }
}
