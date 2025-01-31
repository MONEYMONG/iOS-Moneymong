public protocol SignRepositoryInterface {
  func kakaoSign() async throws -> KakaoAuthInfo
  func appleSign() async throws -> AppleAuthInfo
  func sign(
    provider: String,
    accessToken: String,
    name: String?,
    code: String?
  ) async throws -> SignInfo
  func recentLoginType() -> LoginType?
}
