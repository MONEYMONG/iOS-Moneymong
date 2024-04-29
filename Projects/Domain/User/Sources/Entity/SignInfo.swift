import Foundation

public struct SignInfo: Decodable {
  public let accessToken: String
  public let refreshToken: String
  public let loginSuccess: Bool
  public let schoolInfoExist: Bool
}
