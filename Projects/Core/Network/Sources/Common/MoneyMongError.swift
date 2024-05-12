import Foundation
import Alamofire

public enum MoneyMongError: LocalizedError {
  case networkError(error: AFError)
  case serverError(errorMessage: String)
  case appError(errorMessage: String)
  case unknown(String? = nil)

  public var errorDescription: String? {
    switch self {
    case .networkError(let AFerror):
      return "네트워크 연결을 확인해주세요"
    case .serverError(let errorMessage):
      return errorMessage
    case .appError(let errorMessage):
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
