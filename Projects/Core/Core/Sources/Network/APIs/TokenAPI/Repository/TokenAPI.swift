import Foundation
import Alamofire

enum TokenAPI {
  case token(RefreshTokenRequestDTO)
}

extension TokenAPI: TargetType {
  var baseURL: URL? {
    return try? Config.base.asURL()
  }

  var path: String {
    switch self {
    case .token: return "v1/tokens"
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
      return .requestJSONEncodable(params: refreshToken)
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
