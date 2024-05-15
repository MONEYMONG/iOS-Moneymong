import Foundation

import Alamofire

enum LedgerAPI {
  case create(id: Int, param: CreateLedgerRequestDTO) // 장부 등록
  case uploadImage(Data)
  case deleteImage(param: ImageDeleteRequestDTO)
  case ledgerList(id: Int, param: LedgerListRequestDTO)
  case ledgerFilterList(id: Int, param: LedgerListRequestDTO)
  case ledgerDetail(id: Int)
}

extension LedgerAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/api/".asURL()
  }
  
  var path: String {
    switch self {
    case .create(let id, _): return "v1/ledger/\(id)"
    case .uploadImage(_): return "v1/images"
    case .deleteImage(_): return "v1/images"
    case .ledgerList(let id, _): return "v2/ledger/\(id)"
    case .ledgerFilterList(let id, _): return "v2/ledger/\(id)/filter"
    case .ledgerDetail(let id): return "v1/ledger-detail/\(id)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .create(_, _): return .post
    case .uploadImage(_): return .post
    case .deleteImage(_): return .delete
    case .ledgerList(_, _): return .get
    case .ledgerFilterList(_, _): return .get
    case .ledgerDetail(_): return .get
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .create(_, let param): return .requestJSONEncodable(param)
    case .uploadImage(let data):
      let multipartFormData = MultipartFormData()
      multipartFormData.append(data, withName: "file", fileName: "\(data).jpeg", mimeType: "image/jpeg")
      return .upload(multipartFormData)
    case .deleteImage(let param):
      return .requestJSONEncodable(param)
    case .ledgerList(_, let param):
      return .requestQuery(param)
    case .ledgerFilterList(_, let param):
      return .requestQuery(param)
    case .ledgerDetail(_):
      return .plain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .uploadImage(_): return ["Content-Type": "multipart/form-data"]
    case .deleteImage(_): return ["Content-Type": "application/json"]
    default: return ["Content-Type": "application/json;charset=UTF-8"]
    }
  }
}

