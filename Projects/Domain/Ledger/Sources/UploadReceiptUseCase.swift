import Foundation

import BaseDomain
import LedgerInterface

public struct UploadReceiptUseCase: UploadReceiptUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(ledgerID: Int, receiptImageUrls: [String]) async throws {
    try await ledgerRepo.receiptImagesUpload(detailId: ledgerID, receiptImageUrls: receiptImageUrls)
  }
}
