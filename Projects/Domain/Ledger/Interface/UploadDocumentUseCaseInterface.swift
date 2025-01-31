public protocol UploadDocumentUseCaseInterface {
  func execute(ledgerID: Int, documentUrls: [String]) async throws
}
