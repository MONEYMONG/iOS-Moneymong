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
  case receiptOCR(param: OCRRequestDTO, data: Data)
  case receiptImagesUpload(detailId: Int, receiptImageUrls: ReceiptUploadRequestDTO) // 영수증 이미지 등록
  case receiptImageDelete(detailId: Int, receiptId: Int) // 영수증 이미지 제거
  case documentImagesUpload(detailId: Int, documentImageUrls: DocumentUploadRequestDTO) // 증빙자료 이미지 등록
  case documentImageDelete(detailId: Int, documentId: Int) // 증빙자료 이미지 제거
}

extension LedgerAPI: TargetType {
  var baseURL: URL? {
    switch self {
    case .receiptOCR:
      return try? "https://rgec3uf4w8.apigw.ntruss.com/custom/v1/27247/c8164e59014063109889b541dc736eeae7690fc5dd305dd0189e6e6ff95cd659/".asURL()
    default:
      return try? Config.base.asURL()
    }
  }
  
  var path: String {
    switch self {
    case .create(let id, _): return "v1/ledger/\(id)"
    case .update(let id, _): return "v2/ledger/ledger-detail/\(id)"
    case .delete(let id): return "v1/ledger-detail/\(id)"
    case .uploadImage: return "v1/images"
    case .deleteImage: return "v1/images"
    case .ledgerList(let id, _): return "v2/ledger/\(id)"
    case .ledgerFilterList(let id, _): return "v2/ledger/\(id)/filter"
    case .ledgerDetail(let id): return "v1/ledger-detail/\(id)"
    case .receiptOCR: return "document/receipt"
    case .receiptImagesUpload(let detailId, _): return "v1/ledger-detail/\(detailId)/ledger-receipt"
    case .receiptImageDelete(let detailId, let receiptId): return "v1/ledger-detail/\(detailId)/ledger-receipt/\(receiptId)"
    case .documentImagesUpload(let detailId, _): return "v1/ledger-detail/\(detailId)/ledger-document"
    case .documentImageDelete(let detailId, let documentId): return "v1/ledger-detail/\(detailId)/ledger-document/\(documentId)"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .create: return .post
    case .delete: return .delete
    case .uploadImage: return .post
    case .deleteImage: return .delete
    case .ledgerList: return .get
    case .ledgerFilterList: return .get
    case .ledgerDetail: return .get
    case .receiptOCR: return .post
    case .receiptImagesUpload: return .post
    case .receiptImageDelete: return .delete
    case .documentImagesUpload: return .post
    case .documentImageDelete: return .delete
    case .update: return .put
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
      return .upload(data: multipartFormData)
    case .deleteImage(let param):
      return .requestJSONEncodable(params: param)
    case .ledgerList(_, let query):
      return .requestJSONEncodable(query: query)
    case .ledgerFilterList(_, let query):
      return .requestJSONEncodable(query: query)
    case .ledgerDetail:
      return .plain
    case let .receiptOCR(param, data):
      let multipartFormData = MultipartFormData()
      multipartFormData.append(data, withName: "file", fileName: "\(data).jpeg", mimeType: "image/jpeg")
      guard let object = try? JSONEncoder().encode(param) else {
        return .upload(data: multipartFormData)
      }

      multipartFormData.append(object, withName: "message")
      
      return .upload(data: multipartFormData)
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
    case .uploadImage: return ["Content-Type": "multipart/form-data"]
    case .deleteImage: return ["Content-Type": "application/json"]
    case .receiptOCR:
      return [
        "Content-Type": "multipart/form-data",
        "X-OCR-SECRET": "WUdRdW9Ld0FobXRIaVRnYmNBY3NYVVhDdkhDR1lRcHQ="
      ]
    default: return ["Content-Type": "application/json;charset=UTF-8"]
    }
  }
}

