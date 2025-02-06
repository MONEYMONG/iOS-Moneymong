import Foundation

import BaseDomain
import LedgerInterface
import Utility

public struct ReceiptOCRUseCase: ReceiptOCRUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(imageData: Data) async throws -> OCRResult {
    let model = try await ledgerRepo.fetchOCR(imageData)
    
    if model.inferResult == "ERROR" {
      FirebaseManager.shared.logEvent(event: .failOCR, parameters: ["infer_result" : model.inferResult])
      throw MoneyMongError.appError(.default, errorMessage: "영수증이 보이도록 정확하게 촬영해주세요")
    } else {
      return model
    }
  }
}
