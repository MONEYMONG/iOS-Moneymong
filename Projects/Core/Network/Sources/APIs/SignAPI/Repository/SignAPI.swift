import Foundation
import Alamofire

enum SignAPI {
  case sign(SignRequestDTO)
}

extension SignAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/".asURL()
  }

  var path: String {
    switch self {
    case .sign: return "api/v1/users"
    }
  }

  var method: HTTPMethod {
    return .post
  }

  var task: HTTPTask {
    switch self {
    case .sign(let requst):
      return .requestJSONEncodable(requst)
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
