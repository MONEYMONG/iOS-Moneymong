public protocol AutoSignUseCaseInterface {
  func execute() async throws -> SignInfo
}
