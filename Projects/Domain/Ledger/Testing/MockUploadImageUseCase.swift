import Foundation

import LedgerInterface
import BaseDomain

public struct MockUploadImageUseCase: UploadImageUseCaseInterface {
  public init() {}
  
  public func execute(imageData: Data) async throws -> ImageInfo {
    ImageInfo(key: "test", url: "")
  }
}
