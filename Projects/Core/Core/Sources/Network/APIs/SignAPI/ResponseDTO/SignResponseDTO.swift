public struct SignResponseDTO: Responsable {
  public let accessToken: String?
  public let refreshToken: String?
  public let loginSuccess: Bool?
  public let schoolInfoExist: Bool?
  public let schoolInfoProvided: Bool?

  public init(
    accessToken: String?, 
    refreshToken: String?,
    loginSuccess: Bool?,
    schoolInfoExist: Bool?,
    schoolInfoProvided: Bool?
  ) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.loginSuccess = loginSuccess
    self.schoolInfoExist = schoolInfoExist
    self.schoolInfoProvided = schoolInfoProvided
  }

  public var toEntity: SignInfo {
    .init(
      accessToken: accessToken ?? "",
      refreshToken: refreshToken ?? "",
      loginSuccess: loginSuccess ?? false,
      schoolInfoExist: schoolInfoExist ?? false,
      schoolInfoProvided: schoolInfoProvided ?? false
    )
  }
}
