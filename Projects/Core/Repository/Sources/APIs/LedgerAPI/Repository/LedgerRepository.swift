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
    documentImageUrls: [String],
    category: String?
  ) async throws {
    let targetType = LedgerAPI.create(
      id: id,
      param: .init(
        storeInfo: storeInfo,
        fundType: fundType.rawValue,
        amount: amount,
        description: description,
        paymentDate: paymentDate,
        documentImageUrls: documentImageUrls,
        category: category
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
        documentImageUrls: ledger.documentImageUrls.map { $0.url },
        category: ledger.category
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
  
  public func fetchReport(agencyID: Int, from: Date, to: Date) async throws -> Report {
    let fromComponents = Calendar.current.dateComponents([.year, .month], from: from)
    let toComponents = Calendar.current.dateComponents([.year, .month], from: to)
    let query = ReportRequestDTO(
      startYear: fromComponents.year ?? 0,
      endYear: toComponents.year ?? 0,
      startMonth: fromComponents.month ?? 1,
      endMonth: toComponents.month ?? 1
    )
    let targetType = LedgerAPI.reports(agencyID: agencyID, query: query)
    return try await networkManager.request(target: targetType, of: ReportResponseDTO.self).toEntity
  }
}

