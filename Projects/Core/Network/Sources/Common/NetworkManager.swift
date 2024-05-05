import Foundation

import Alamofire

public protocol NetworkManagerInterfacae {
  @discardableResult
  func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO
  func request(target: TargetType) async throws
}

public final class NetworkManager: NetworkManagerInterfacae {

  public var tokenIntercepter: TokenRequestIntercepter?

  public init() {}
  
  public func request(target: TargetType) async throws {
    if #available(iOS 16.0, *) {
      print("start")
      try! await Task.sleep(for: .seconds(2))
      print("end")
    }
    
    let dataResponse = await AF.request(target, interceptor: tokenIntercepter)
      .serializingData()
      .response
    
    guard let statusCode = dataResponse.response?.statusCode else {
      throw MoneyMongError.serverError(errorMessage: "Empty StatusCode")
    }
    
    // CommonError로 디코딩
    if let data = dataResponse.data,
       (400..<500) ~= statusCode,
       let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
    {
      throw MoneyMongError.appError(errorMessage: errorResponse.message)
    }
    
    // 200일때
    if (200..<300) ~= statusCode {
      return
    }
    
    assertionFailure("잘못됬거나, 서버에러!")
  }

  public func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO {
    if #available(iOS 16.0, *) {
      print("start")
      try! await Task.sleep(for: .seconds(2))
      print("end")
    }
    
    let dataResponse = await AF.request(target, interceptor: tokenIntercepter)
      .serializingData()
      .response
    
    guard let statusCode = dataResponse.response?.statusCode else {
      throw MoneyMongError.serverError(errorMessage: "Empty StatusCode")
    }
    
    switch dataResponse.result {
    case let .success(data):
      // DTO로 디코딩
      if let dto = try? JSONDecoder().decode(type, from: data),
         (200..<300) ~= statusCode
      {
        return dto
      }
      // CommonError로 디코딩
      if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data),
         (400..<500) ~= statusCode
      {
        throw MoneyMongError.appError(errorMessage: errorResponse.message)
      }
      
      assertionFailure("dto디코딩, error디코딩 모두 실패 이러면 안되요 디버깅 해주세요")
      
      throw MoneyMongError.appError(errorMessage: "디코딩 실패")
    case let .failure(error):
      assertionFailure("서버동작 에러! 적절한 처리 필요 \(error.localizedDescription)")
      throw error
    }
  }
}
