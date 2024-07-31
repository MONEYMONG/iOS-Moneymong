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
    
    let dataResponse = await AF.request(target, interceptor: tokenIntercepter)
      .validateTokenExpire()
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
      if let message = errorResponse.message {
        throw MoneyMongError.appError(
          MoneyMongError.Code(rawValue: errorResponse.code) ?? .default,
          errorMessage: message
        )
      }
      
      if let messages = errorResponse.messages {
        throw MoneyMongError.appError(
          MoneyMongError.Code(rawValue: errorResponse.code) ?? .default,
          errorMessage: messages.joined(separator: "\n")
        )
      }
    }
    
    // 200일때
    if (200..<300) ~= statusCode {
      return
    }
    
    assertionFailure("잘못됬거나, 서버에러!")
  }
  
  public func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO {
    
    let dataRequest: DataRequest
    switch target.task {
    case .upload(let multipartFormData):
      dataRequest = AF.upload(
        multipartFormData: multipartFormData,
        with: target,
        interceptor: tokenIntercepter
      )
      .validateTokenExpire()
      
    default:
      dataRequest = AF.request(
        target,
        interceptor: tokenIntercepter
      )
      .validateTokenExpire()
    }

    let dataResponse = await dataRequest.serializingData().response

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
        if let message = errorResponse.message {
          throw MoneyMongError.appError(
            MoneyMongError.Code(rawValue: errorResponse.code) ?? .default,
            errorMessage: message
          )
        }
        
        if let messages = errorResponse.messages {
          throw MoneyMongError.appError(
            MoneyMongError.Code(rawValue: errorResponse.code) ?? .default,
            errorMessage: messages.joined(separator: "\n")
          )
        }
      }
      
      assertionFailure("dto디코딩, error디코딩 모두 실패 이러면 안되요 디버깅 해주세요")
      
      throw MoneyMongError.appError(.default, errorMessage: "디코딩 실패")
    case let .failure(error):
      assertionFailure("서버동작 에러! 적절한 처리 필요 \(error.localizedDescription)")
      throw error
    }
  }
}

extension DataRequest {
  public func validateTokenExpire() -> Self {
    return validate { request,response,data in
      if response.statusCode == 401 {
        let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: 401)
        return .failure(AFError.responseValidationFailed(reason: reason))
      } else {
        return .success(())
      }
    }
  }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
