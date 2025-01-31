public protocol DeleteReceiptUseCaseInterface {
  func execute(ledgerID: Int, receiptID: Int) async throws
}
