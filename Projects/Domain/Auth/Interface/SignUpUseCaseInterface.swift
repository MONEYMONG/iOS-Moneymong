public protocol SignUpUseCaseInterface {
  func execute(loginType: LoginType) async throws -> SignInfo
}
