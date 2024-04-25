import Foundation

import Alamofire

public protocol NetworkManagerInterfacae {
  func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO
}

public final class NetworkManager: NetworkManagerInterfacae {
  
  public init() {}
  
  public func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO {
    let dataResponse = await AF.request(target)
      .serializingData()
      .response
    switch dataResponse.result {
    case let .success(data):
      return try JSONDecoder().decode(type, from: data)
    case let .failure(error):
      throw error
    }
  }
}
