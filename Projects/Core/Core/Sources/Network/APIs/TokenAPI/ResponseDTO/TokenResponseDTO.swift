public struct TokenResponseDTO: Responsable {
  public let accessToken: String?
  public let refreshToken: String?

  public init(accessToken: String?, refreshToken: String?) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }

  public var toEntity: Token {
    .init(accessToken: accessToken ?? "", refreshToken: refreshToken ?? "")
  }
}

