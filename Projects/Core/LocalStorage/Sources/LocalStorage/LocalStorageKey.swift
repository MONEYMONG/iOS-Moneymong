import Foundation

public enum LocalStorageKey {
  case keychain(Keychain)
  case userDefault(UD)
  
  public enum Keychain: String {
    case accessToken
    case refreshToken
    case socialAccessToken
  }
  
  public enum UD: String {
    case recentLoginType // 최근 로그인 타입
    case selectedAgency // 현재 선택된 소속 (맴버화면)
    case userID // 유저정보
  }
  
  public var id: String {
    switch self {
    case let .keychain(value):
      return value.rawValue
    case let .userDefault(value):
      return value.rawValue
    }
  }
}
