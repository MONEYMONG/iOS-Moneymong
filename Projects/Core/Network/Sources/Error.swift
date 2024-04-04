import Foundation
import Moya

public enum MoneyMongError: LocalizedError {
  case networkError(moyaError: MoyaError)
  case serverError(errorMessage: String)
  case unknown(String? = nil)

  public var errorDescription: String? {
    switch self {
    case .networkError(let moyaError):
      return moyaError.errorDescription
    case .serverError(let errorMessage):
      return errorMessage
    case .unknown(let errorDescription):
      return errorDescription
    }
  }
}
