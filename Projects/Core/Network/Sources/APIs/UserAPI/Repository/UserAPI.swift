import Foundation

enum UserAPI {
  case user // 내정보 조회
  case logout(LogoutRequestDTO) // 로그아웃
  case withdrawl // 회원탈퇴
}

extension UserAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/api/v1".asURL()
  }
  
  var path: String {
    switch self {
    case .user: return "/users/me"
    case .logout: return "/tokens"
    case .withdrawl: return "/users/me"
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
    case let .logout(param): return .requestJSONEncodable(param)
    case .withdrawl: return .plain
    }
  }
  
  var headers: [String : String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9VU0VSIiwidXNlcklkIjozLCJpYXQiOjE3MDQ3MTU0NTEsImV4cCI6MTczNjI3MzA1MX0.2yYEy71Gz4YIz0DYzlx0glYMgZA0JAZs05jsVRvvQx4"
    ]
  }
}
