import Foundation

import BaseDomain
import LedgerInterface

public struct CreateLedgerUseCase: CreateLedgerUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(
    id: Int,
    storeInfo: String,
    fundType: FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    documentImageUrls: [String]
  ) async throws {
    try await ledgerRepo.create(
      id: id,
      storeInfo: storeInfo,
      fundType: fundType,
      amount: amount,
      description: description,
      paymentDate: paymentDate,
      documentImageUrls: documentImageUrls
    )
  }
}
