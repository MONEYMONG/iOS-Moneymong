import Foundation
import Alamofire

public enum MoneyMongError: LocalizedError {
  public enum Code: String {
    case ledgerAmountOverflow = "LEDGER-005"
    case ledgerAmountUnderflow = "LEDGER-008"
    case cameraAccess
    case `default`
  }
  case networkError(error: AFError)
  case serverError(errorMessage: String)
  case appError(Code, errorMessage: String)
  case unknown(String? = nil)
  
  public var errorTitle: String {
    switch self {
    case let .appError(code, _):
      switch code {
      case .ledgerAmountOverflow,
          .ledgerAmountUnderflow: return "기록할 수 있는 총 잔액을 초과했습니다"
      case .cameraAccess: return "현재 머니몽이\n카메라에 접근할 수 없어요"
      default: return "에러"
      }
    default: return "에러"
    }
  }

  public var errorDescription: String? {
    switch self {
    case .networkError(let AFerror):
      return "네트워크 연결을 확인해주세요"
    case .serverError(let errorMessage):
      return errorMessage
    case .appError(_, let errorMessage):
      return errorMessage
    case .unknown(let errorDescription):
      return errorDescription
    }
  }
}

public extension Error {
  var toMMError: MoneyMongError {
    return self as? MoneyMongError ?? .unknown(localizedDescription)
  }
}
