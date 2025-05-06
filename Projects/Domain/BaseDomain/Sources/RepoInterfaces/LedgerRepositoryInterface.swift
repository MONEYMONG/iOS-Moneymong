import Foundation

public protocol LedgerRepositoryInterface {
  func imageUpload(_ data: Data) async throws -> ImageInfo
  func imageDelete(_ image: ImageInfo) async throws
  func fetchLedgerDetail(id: Int) async throws -> LedgerDetail
  func create(
    id: Int,
    storeInfo: String,
    fundType: FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    receiptImageUrls: [String],
    documentImageUrls: [String]
  ) async throws
  func update(ledger: LedgerDetail) async throws -> LedgerDetail
  func delete(id: Int) async throws
  func fetchLedgerList(
    id: Int,
    start: DateInfo,
    end: DateInfo,
    page: Int,
    limit: Int,
    fundType: FundType?
  ) async throws -> LedgerList
  func receiptImagesUpload(detailId: Int, receiptImageUrls: [String]) async throws
  func receiptImageDelete(detailId: Int, receiptId: Int) async throws
  func documentImagesUpload(detailId: Int, documentImageUrls: [String]) async throws
  func documentImageDelete(detailId: Int, documentId: Int) async throws
  func saveDateRange(_ dateRange: DateRange)
  func fetchDateRange() -> DateRange?
}
