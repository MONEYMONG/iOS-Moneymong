import Foundation

import BaseDomain

public protocol ReceiptOCRUseCaseInterface {
  func execute(imageData: Data) async throws -> OCRResult
}
