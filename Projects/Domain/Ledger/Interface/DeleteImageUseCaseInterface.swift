public protocol DeleteImageUseCaseInterface {
  func execute(_ imageInfo: ImageInfo) async throws
}
