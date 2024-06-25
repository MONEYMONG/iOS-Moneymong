import Foundation
import Alamofire

enum UniversityAPI {
  case universities(String)
  case university(UniversityRequestDTO)
}

extension UniversityAPI: TargetType {
  var baseURL: URL? {
    return try? Config.base.asURL()
  }

  var path: String {
    switch self {
    case .universities(let keyword): return "v1/universities?keyword=\(keyword)"
    case .university: return "v1/user-university"
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
    case .universities:
      return .plain
    case .university(let requestDTO):
      return .requestJSONEncodable(params: requestDTO)
    }
  }
  
  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8",
    ]
  }
}
