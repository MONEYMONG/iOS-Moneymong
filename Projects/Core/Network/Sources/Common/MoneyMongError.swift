import Foundation
import Alamofire

public enum MoneyMongError: LocalizedError {
  public enum `Type`: String {
    case network
    case camera
    case normal
  }
  case networkError(error: AFError)
  case serverError(errorMessage: String)
  case appError(Type, errorMessage: String)
  case unknown(String? = nil)
  
  public var errorTitle: String {
    switch self {
    case .networkError:
      return "네트워크 에러"
    case .serverError:
      return "네트워크 에러"
    case let .appError(type, _):
      switch type {
      case .network:
        return "네트워크 에러"
      case .camera:
        return "현재 머니몽이\n카메라에 접근할 수 없어요"
      case .normal:
        return "에러"
      }
    case .unknown:
      return "에러"
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
