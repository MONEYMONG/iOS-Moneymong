public protocol UploadReceiptUseCaseInterface {
  func execute(ledgerID: Int, receiptImageUrls: [String]) async throws
}
