import Foundation

import BaseDomain

public protocol UploadImageUseCaseInterface {
  func execute(imageData: Data) async throws -> ImageInfo
}
