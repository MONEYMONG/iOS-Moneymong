import Foundation

import Core
import LedgerInterface

public struct ReceiptOCRUseCase: ReceiptOCRUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(imageData: Data) async throws -> OCRResult {
    try await ledgerRepo.fetchOCR(imageData)
  }
}
