import Foundation

public enum MoneyMongError: LocalizedError {
  public enum Code: String {
    case ledgerAmountOverflow = "LEDGER-005"
    case ledgerAmountUnderflow = "LEDGER-008"
    case `default`
  }
  case networkError(errorMessage: String)
  case serverError(errorMessage: String)
  case appError(Code, errorMessage: String)
  case unknown(String? = nil)
  
  public var errorTitle: String {
    switch self {
    case let .appError(code, _):
      switch code {
      case .ledgerAmountOverflow, .ledgerAmountUnderflow:
        return "기록할 수 있는 총 잔액을 초과했습니다"
      default: return "에러"
      }
    default: return "에러"
    }
  }

  public var errorDescription: String? {
    switch self {
    case .networkError:
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
