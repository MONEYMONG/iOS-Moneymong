import Foundation

public protocol ReceiptOCRUseCaseInterface {
  func execute(imageData: Data) async throws -> OCRResult
}
