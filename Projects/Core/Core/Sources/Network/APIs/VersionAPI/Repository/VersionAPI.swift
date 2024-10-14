import Foundation

enum VersionAPI {
  case version(VersionRequestDTO) // 버전조회
}

extension VersionAPI: TargetType {
  var baseURL: URL? {
    return try? Config.base.asURL()
  }
  
  var path: String {
    switch self {
    case .version:
      return "v1/version"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .version:
      return .post
    }
  }
  
  var task: HTTPTask {
    switch self {
    case let .version(param):
      return .requestJSONEncodable(params: param)
    }
  }
  
  var headers: [String : String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
