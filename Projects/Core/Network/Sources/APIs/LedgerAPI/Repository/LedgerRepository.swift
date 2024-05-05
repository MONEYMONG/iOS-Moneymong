import Foundation

import LocalStorage

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
  func imageUpload(_ data: Data) async throws -> ImageURL
  func imageDelete(_ image: ImageURL) async throws
}

public final class LedgerRepository: LedgerRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
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
  
  public func imageUpload(_ data: Data) async throws -> ImageURL {
    let targetType = LedgerAPI.uploadImage(data)
    return try await networkManager.request(target: targetType, of: ImageResponseDTO.self).toEntity
  }
  
  public func imageDelete(_ image: ImageURL) async throws {
    let targetType = LedgerAPI.deleteImage(
      param: .init(key: image.key, path: image.url)
    )
    try await networkManager.request(target: targetType)
  }
}

