public struct AppleAuthInfo {
  public let idToken: String
  public let name: String?
  public let authorizationCode: String

  public init(idToken: String, name: String? = nil, authorizationCode: String) {
    self.idToken = idToken
    self.name = name
    self.authorizationCode = authorizationCode
  }
}
