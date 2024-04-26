import Foundation

/// 로그아웃
public struct LogoutResponseDTO: Responsable {
  let refreshToken: String
  
  public var toEntity: String {
    return refreshToken
  }
}
