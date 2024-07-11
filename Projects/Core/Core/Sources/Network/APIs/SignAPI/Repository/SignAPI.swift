import Foundation

enum SignAPI {
  case sign(SignRequestDTO)
}

extension SignAPI: TargetType {
  var baseURL: URL? {
    return try? Config.base.asURL()
  }

  var path: String {
    switch self {
    case .sign: return "v1/users"
    }
  }

  var method: HTTPMethod {
    return .post
  }

  var task: HTTPTask {
    switch self {
    case .sign(let requst):
      return .requestJSONEncodable(params: requst)
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
