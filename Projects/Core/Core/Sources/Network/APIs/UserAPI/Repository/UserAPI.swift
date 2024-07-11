import Foundation

enum UserAPI {
  case user // 내정보 조회
  case logout(LogoutRequestDTO) // 로그아웃
  case withdrawl // 회원탈퇴
}

extension UserAPI: TargetType {
  var baseURL: URL? {
    return try? Config.base.asURL()
  }
  
  var path: String {
    switch self {
    case .user: return "v1/users/me"
    case .logout: return "v1/tokens"
    case .withdrawl: return "v1/users/me"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .user: return .get
    case .logout: return .delete
    case .withdrawl: return .delete
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .user: return .plain
    case let .logout(param): return .requestJSONEncodable(params: param)
    case .withdrawl: return .plain
    }
  }
  
  var headers: [String : String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
