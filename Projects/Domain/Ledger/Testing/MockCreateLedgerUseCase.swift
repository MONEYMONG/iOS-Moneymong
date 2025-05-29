import LedgerInterface
import BaseDomain

public struct MockCreateLedgerUseCase: CreateLedgerUseCaseInterface {
  public init() {}
  
  public func execute(id: Int, storeInfo: String, fundType: BaseDomain.FundType, amount: Int, description: String, paymentDate: String, documentImageUrls: [String]) async throws { print(#filePath, #function) }
}
