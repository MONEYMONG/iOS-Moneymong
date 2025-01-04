import Foundation

import Core
import LedgerInterface

public struct DeleteReceiptUseCase: DeleteReceiptUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(ledgerID: Int, receiptID: Int) async throws {
    try await ledgerRepo.receiptImageDelete(detailId: ledgerID, receiptId: receiptID)
  }
}
