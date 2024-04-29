import Foundation

enum AgencyAPI {
  
}

extension AgencyAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/".asURL()
  }

  var path: String {
    switch self {
    default: return ""
    }
  }

  var method: HTTPMethod {
    switch self {
    default: return .get
    }
  }

  var task: HTTPTask {
    switch self {
    default: return .plain
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9VU0VSIiwidXNlcklkIjozLCJpYXQiOjE3MDQ3MTU0NTEsImV4cCI6MTczNjI3MzA1MX0.2yYEy71Gz4YIz0DYzlx0glYMgZA0JAZs05jsVRvvQx4"
    ]
  }
}
