import Foundation
import Alamofire

public enum MoneyMongError: LocalizedError {
  case networkError(AFerror: AFError)
  case serverError(errorMessage: String)
  case unknown(String? = nil)

  public var errorDescription: String? {
    switch self {
    case .networkError(let AFerror):
      return AFerror.errorDescription
    case .serverError(let errorMessage):
      return errorMessage
    case .unknown(let errorDescription):
      return errorDescription
    }
  }
}
