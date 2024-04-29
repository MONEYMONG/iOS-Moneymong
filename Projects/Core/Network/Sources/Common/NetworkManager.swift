import Foundation

import Alamofire

public protocol NetworkManagerInterfacae {
  @discardableResult
  func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO
}

extension NetworkManagerInterfacae {
  func request(target: TargetType) async throws {
    try await self.request(target: target, of: EmptyResponse.self)
  }
}

public final class NetworkManager: NetworkManagerInterfacae {
  
  public init() {}

  public func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO {
    let dataResponse = await AF.request(target)
      .serializingData()
      .response
    
    guard let statusCode = dataResponse.response?.statusCode else {
      throw MoneyMongError.serverError(errorMessage: "Empty StatusCode")
    }
    
    guard (200..<300) ~= statusCode else {
      throw MoneyMongError.serverError(errorMessage: "InvalidStatusCode \(statusCode)")
    }
    
    switch dataResponse.result {
    case let .success(data):
      if let dto = try? JSONDecoder().decode(type, from: data) {
        return dto
      }
      
      if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
        throw MoneyMongError.appError(errorMessage: errorResponse.message)
      }
      
      throw MoneyMongError.appError(errorMessage: "디코딩 실패")
    case let .failure(error):
      throw error
    }
  }
}
