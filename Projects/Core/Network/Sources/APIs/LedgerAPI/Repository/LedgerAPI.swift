import Foundation

enum LedgerAPI {
  case create(id: Int, param: CreateLedgerRequestDTO) // 장부 등록
}

extension LedgerAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/api/".asURL()
  }
  
  var path: String {
    switch self {
    case .create(let id, _): return "v1//ledger/\(id)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .create(_, _): return .post
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .create(_, let param): .requestJSONEncodable(param)
    }
  }
  
  var headers: [String : String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"
    ]
  }
}
