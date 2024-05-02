import Foundation

public protocol LedgerRepositoryInterface {
  func create(
    id: Int,
    storeInfo: String,
    fundType: LedgerDetail.FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    receiptImageUrls: [String],
    documentImageUrls: [String]
  ) async throws
}

public final class LedgerRepository: LedgerRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae = NetworkManager()) {
    self.networkManager = networkManager
  }
  
  public func create(
    id: Int,
    storeInfo: String,
    fundType: LedgerDetail.FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    receiptImageUrls: [String],
    documentImageUrls: [String]
  ) async throws {
    let targetType = LedgerAPI.create(
      id: id,
      param: .init(
        storeInfo: storeInfo,
        fundType: fundType.rawValue,
        amount: amount,
        description: description,
        paymentDate: paymentDate,
        receiptImageUrls: receiptImageUrls,
        documentImageUrls: receiptImageUrls
      )
    )
    _ = try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self)
  }
}

