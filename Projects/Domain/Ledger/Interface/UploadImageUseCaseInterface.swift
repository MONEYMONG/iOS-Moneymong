import Foundation

public protocol UploadImageUseCaseInterface {
  func execute(imageData: Data) async throws -> ImageInfo
}
