import Foundation

import BaseDomain
import LedgerInterface

public struct UploadDocumentUseCase: UploadDocumentUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(ledgerID: Int, documentUrls: [String]) async throws {
    try await ledgerRepo.documentImagesUpload(detailId: ledgerID, documentImageUrls: documentUrls)
  }
}
