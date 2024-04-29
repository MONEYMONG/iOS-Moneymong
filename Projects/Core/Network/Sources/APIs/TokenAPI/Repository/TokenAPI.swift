import Foundation
import Alamofire

enum TokenAPI {
  case token(refreshToken: String)
}

extension TokenAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/".asURL()
  }

  var path: String {
    switch self {
    case .token: return "api/v1/tokens"
    }
  }

  var method: HTTPMethod {
    switch self {
      case .token: return .post
      }
  }

  var task: HTTPTask {
    switch self {
    case .token(let refreshToken):
      return .requestJSONEncodable(refreshToken)
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
