import Foundation
import Alamofire

enum UniversityAPI {
  case universities(String)
  case university(UniversityRequestDTO)
}

extension UniversityAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/".asURL()
  }

  var path: String {
    switch self {
    case .universities: return "api/v1/universities"
    case .university: return "api/v1/user-university"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .universities: return .get
    case .university: return .post
    }
  }

  var task: HTTPTask {
    switch self {
    case .universities(let keywork):
      return .requestJSONEncodable(keywork)
    case .university(let requestDTO):
      return .requestJSONEncodable(requestDTO)
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8",
    ]
  }
}
