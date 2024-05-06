import Foundation

import Alamofire

enum LedgerAPI {
  case create(id: Int, param: CreateLedgerRequestDTO) // 장부 등록
  case uploadImage(Data)
  case deleteImage(param: ImageDeleteRequestDTO)
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
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .create(_, _): return .post
    case .uploadImage(_): return .post
    case .deleteImage(_): return .delete
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
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .create(_, _): return ["Content-Type": "application/json;charset=UTF-8"]
    case .uploadImage(_): return ["Content-Type": "multipart/form-data"]
    case .deleteImage(_): return ["Content-Type": "application/json"]
    }
  }
}

