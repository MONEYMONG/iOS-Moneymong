import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface
import Utility

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
    fundType: FundType,
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
        documentImageUrls: documentImageUrls
      )
    )
    let ledger = try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self)
    FirebaseManager.shared.logEvent(
      event: .createLedgerItem,
      parameters: [
        "ledger_id" : ledger.id,
        "store_info" : ledger.storeInfo,
        "fund_type" : ledger.fundType,
        "amount" : ledger.amount,
        "memo" : ledger.description,
        "payment_date": ledger.paymentDate,
        "receipt_image_urls": ledger.receiptImageUrls,
        "document_image_urls": ledger.documentImageUrls,
        "author_name" : ledger.authorName,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
  }

  public func update(ledger: LedgerDetail) async throws -> LedgerDetail {
    let targetType = LedgerAPI.update(
      id: ledger.id,
      param: .init(
        storeInfo: ledger.storeInfo,
        fundType: ledger.fundType.rawValue,
        amount: ledger.amount,
        description: ledger.description,
        paymentDate: ledger.paymentDate,
        receiptImageUrls: ledger.receiptImageUrls.map { $0.url },
        documentImageUrls: ledger.documentImageUrls.map { $0.url }
      )
    )
    let entity = try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self).toEntity
    FirebaseManager.shared.logEvent(
      event: .updateLedgerItem,
      parameters: [
        "ledger_id" : entity.id,
        "store_info" : entity.storeInfo,
        "fund_type" : entity.fundType.rawValue,
        "amount" : entity.amount,
        "memo" : entity.description,
        "payment_date": entity.paymentDate,
        "receipt_image_urls": entity.receiptImageUrls,
        "document_image_urls": entity.documentImageUrls,
        "author_name" : entity.authorName,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
    return entity
  }

  public func delete(id: Int) async throws {
    let targetType = LedgerAPI.delete(id: id)
    try await networkManager.request(target: targetType)
    FirebaseManager.shared.logEvent(
      event: .deleteLedgerItem,
      parameters: [
        "ledger_id" : id,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
  }

  public func imageUpload(_ data: Data) async throws -> ImageInfo {
    let targetType = LedgerAPI.uploadImage(data)
    return try await networkManager.request(target: targetType, of: ImageResponseDTO.self).toEntity
  }
  
  public func imageDelete(_ image: ImageInfo) async throws {
    let targetType = LedgerAPI.deleteImage(
      param: .init(key: image.key, path: image.url)
    )
    try await networkManager.request(target: targetType)
  }
  
  public func fetchLedgerList(
    id: Int,
    start: DateInfo,
    end: DateInfo,
    page: Int,
    limit: Int,
    fundType: FundType?
  ) async throws -> LedgerList {
    let request = LedgerListRequestDTO(
      startYear: start.year,
      endYear: end.year,
      startMonth: start.month,
      endMonth: end.month,
      page: page,
      limit: limit,
      fundType: fundType?.rawValue
    )
    let targetType: TargetType
    if fundType == nil {
      targetType = LedgerAPI.ledgerList(id: id, param: request)
    } else {
      targetType = LedgerAPI.ledgerFilterList(id: id, param: request)
    }
    
    let result = try await networkManager.request(target: targetType, of: LedgerListResponseDTO.self)
    
    localStorage.saveCurrentLedgerInfo(
      agencyName: result.agencyName,
      totalBalance: result.totalBalance
    )
    return result.toEntity
  }
  
  public func fetchLedgerDetail(id: Int) async throws -> LedgerDetail {
    let targetType = LedgerAPI.ledgerDetail(id: id)
    return try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self).toEntity
  }
  
  public func fetchOCR(_ data: Data) async throws -> OCRResult {
    let dto = OCRRequestDTO(
      requestId: UUID().uuidString,
      images: [
        .init(format: "jpeg", name: "receipt")
      ])
    let targetType = LedgerAPI.receiptOCR(param: dto, data: data)
    return try await networkManager.request(target: targetType, of: OCRResponseDTO.self).toEntity
  }

  public func receiptImagesUpload(detailId: Int, receiptImageUrls: [String]) async throws {
    let targetType = LedgerAPI.receiptImagesUpload(
      detailId: detailId,
      receiptImageUrls: ReceiptUploadRequestDTO(receiptImageUrls: receiptImageUrls)
    )
    return try await networkManager.request(target: targetType)
  }

  public func receiptImageDelete(detailId: Int, receiptId: Int) async throws {
    let targetType = LedgerAPI.receiptImageDelete(detailId: detailId, receiptId: receiptId)
    return try await networkManager.request(target: targetType)
  }

  public func documentImagesUpload(detailId: Int, documentImageUrls: [String]) async throws {
    let targetType = LedgerAPI.documentImagesUpload(
      detailId: detailId,
      documentImageUrls: DocumentUploadRequestDTO(documentImageUrls: documentImageUrls)
    )
    return try await networkManager.request(target: targetType)
  }

  public func documentImageDelete(detailId: Int, documentId: Int) async throws {
    let targetType = LedgerAPI.documentImageDelete(detailId: detailId, documentId: documentId)
    return try await networkManager.request(target: targetType)
  }
  
  public func saveDateRange(_ dateRange: DateRange) {
    localStorage.ledgerDateRange = dateRange.toDic
  }
  
  public func fetchDateRange() -> DateRange? {
    guard let dateRange = localStorage.ledgerDateRange else { return nil }
    return DateRange(dic: dateRange)
  }
}

