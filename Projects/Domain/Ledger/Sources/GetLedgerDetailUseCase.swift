import Foundation

import BaseDomain
import LedgerInterface

public struct GetLedgerDetailUseCase: GetLedgerDetailUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(id: Int) async throws -> LedgerDetail {
    try await ledgerRepo.fetchLedgerDetail(id: id)
  }
}
