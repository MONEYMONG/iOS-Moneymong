public struct SignInfo {
  public let accessToken: String
  public let refreshToken: String
  public let loginSuccess: Bool
  public let schoolInfoExist: Bool
  public let schoolInfoProvided: Bool
  
  public init(accessToken: String, refreshToken: String, loginSuccess: Bool, schoolInfoExist: Bool, schoolInfoProvided: Bool) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.loginSuccess = loginSuccess
    self.schoolInfoExist = schoolInfoExist
    self.schoolInfoProvided = schoolInfoProvided
  }
}
