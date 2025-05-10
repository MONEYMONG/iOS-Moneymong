import BaseDomain

public protocol CreateLedgerUseCaseInterface {
  func execute(
    id: Int,
    storeInfo: String,
    fundType: FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    documentImageUrls: [String]
  ) async throws
}
