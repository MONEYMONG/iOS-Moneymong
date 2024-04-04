import Foundation

public struct SignModelResponseDTO: Decodable {
  let accessToken: String?
  let refreshToken: String?
  let loginSuccess: Bool?
  let schoolInfoExist: Bool?
}
