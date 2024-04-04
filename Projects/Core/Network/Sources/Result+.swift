import Foundation
import Moya

public extension Result where Success == Data, Failure == MoyaError {
  func decode<T: Decodable>(_ type: T.Type) throws -> T {
    do {
      switch self {
      case .success(let data):
        return try JSONDecoder().decode(type, from: data)
      case .failure(let error):
        throw MoneyMongError.networkError(moyaError: error)
      }
    }
  }
}

