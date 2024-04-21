import Foundation

public struct SignModelResponseDTO: Decodable {
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
}

public struct GenericResponse<T: Decodable>: Decodable {
  let data: T?
}
