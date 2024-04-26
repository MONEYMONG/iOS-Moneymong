import Foundation
import Alamofire

enum UserAPI {
  case user // 내정보 조회
  case logout // 로그아웃
}

extension UserAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/api/v1".asURL()
  }
  
  var path: String {
    switch self {
    case .user:
      return "/users/me"
    case .logout:
      return "/tokens"
    }
  }
  
  var method: Alamofire.HTTPMethod {
    switch self {
    case .user: return .get
    case .logout: return .delete
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .user: return .plain
    case .logout: return .plain
    }
  }
  
  var headers: [String : String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9VU0VSIiwidXNlcklkIjozLCJpYXQiOjE3MDQ3MTU0NTEsImV4cCI6MTczNjI3MzA1MX0.2yYEy71Gz4YIz0DYzlx0glYMgZA0JAZs05jsVRvvQx4"
    ]
  }
}
