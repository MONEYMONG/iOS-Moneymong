public protocol DeleteDocumentUseCaseInterface {
  func execute(ledgerID: Int, documentID: Int) async throws
}
