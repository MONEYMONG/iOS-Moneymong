import Foundation

import BaseDomain
import LedgerInterface

public struct DeleteDocumentUseCase: DeleteDocumentUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(ledgerID: Int, documentID: Int) async throws {
    try await ledgerRepo.documentImageDelete(detailId: ledgerID, documentId: documentID)
  }
}
