public struct SignResponseDTO: Responsable {
  public let accessToken: String?
  public let refreshToken: String?
  public let loginSuccess: Bool?
  public let schoolInfoExist: Bool?

  public init(accessToken: String?, refreshToken: String?, loginSuccess: Bool?, schoolInfoExist: Bool?) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.loginSuccess = loginSuccess
    self.schoolInfoExist = schoolInfoExist
  }

  public var toEntity: SignInfo {
    .init(
      accessToken: accessToken ?? "",
      refreshToken: refreshToken ?? "",
      loginSuccess: loginSuccess ?? false,
      schoolInfoExist: schoolInfoExist ?? false
    )
  }
}
