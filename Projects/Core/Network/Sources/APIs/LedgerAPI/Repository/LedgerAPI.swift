import Foundation

import Alamofire

enum LedgerAPI {
  case create(id: Int, param: LedgerRequestDTO) // 장부 등록
  case update(id: Int, param: LedgerRequestDTO) // 장부 정보 변경
  case delete(id: Int) // 장부 삭제
  case uploadImage(Data)
  case deleteImage(param: ImageDeleteRequestDTO)
  case ledgerList(id: Int, param: LedgerListRequestDTO)
  case ledgerFilterList(id: Int, param: LedgerListRequestDTO)
  case ledgerDetail(id: Int)
  case receiptImagesUpload(detailId: Int, receiptImageUrls: ReceiptUploadRequestDTO) // 영수증 이미지 등록
  case receiptImageDelete(detailId: Int, receiptId: Int) // 영수증 이미지 제거
  case documentImagesUpload(detailId: Int, documentImageUrls: DocumentUploadRequestDTO) // 증빙자료 이미지 등록
  case documentImageDelete(detailId: Int, documentId: Int) // 증빙자료 이미지 제거
}

extension LedgerAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/api/".asURL()
  }
  
  var path: String {
    switch self {
    case .create(let id, _): return "v1/ledger/\(id)"
    case .update(let id, _): return "v1/ledger/ledger-detail/\(id)"
    case .delete(let id): return "v1/ledger-detail/\(id)"
    case .uploadImage(_): return "v1/images"
    case .deleteImage(_): return "v1/images"
    case .ledgerList(let id, _): return "v2/ledger/\(id)"
    case .ledgerFilterList(let id, _): return "v2/ledger/\(id)/filter"
    case .ledgerDetail(let id): return "v1/ledger-detail/\(id)"
    case .receiptImagesUpload(let detailId, _): return "v1/ledger-detail/\(detailId)/ledger-receipt"
    case .receiptImageDelete(let detailId, let receiptId): return "v1/ledger-detail/\(detailId)/ledger-receipt/\(receiptId)}"
    case .documentImagesUpload(let detailId, _): return "v1/ledger-detail/\(detailId)/ledger-document"
    case .documentImageDelete(let detailId, let documentId): return "v1/ledger-detail/\(detailId)/ledger-document/\(documentId)"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .create(_, _): return .post
    case .update: return .put
    case .delete: return .delete
    case .uploadImage(_): return .post
    case .deleteImage(_): return .delete
    case .ledgerList(_, _): return .get
    case .ledgerFilterList(_, _): return .get
    case .ledgerDetail(_): return .get
    case .receiptImagesUpload: return .post
    case .receiptImageDelete: return .delete
    case .documentImagesUpload: return .post
    case .documentImageDelete: return .delete
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .create(_, let param): 
      return .requestJSONEncodable(params: param)
    case .update(_, let param):
      return .requestJSONEncodable(params: param)
    case .delete: return .plain
    case .uploadImage(let data):
      let multipartFormData = MultipartFormData()
      multipartFormData.append(data, withName: "file", fileName: "\(data).jpeg", mimeType: "image/jpeg")
      return .upload(multipartFormData)
    case .deleteImage(let param):
      return .requestJSONEncodable(params: param)
    case .ledgerList(_, let query):
      return .requestJSONEncodable(query: query)
    case .ledgerFilterList(_, let query):
      return .requestJSONEncodable(query: query)
    case .ledgerDetail(_):
      return .plain
    case .receiptImagesUpload(_, let receiptImageUrls):
      return .requestJSONEncodable(params: receiptImageUrls)
    case .receiptImageDelete:
      return .plain
    case .documentImagesUpload(_, let documentImageUrls):
      return .requestJSONEncodable(params: documentImageUrls)
    case .documentImageDelete:
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

