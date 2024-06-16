import UIKit

import LocalStorage
import Alamofire

public final class TokenRequestIntercepter: RequestInterceptor {
  private let localStorage: LocalStorageInterface
  private let tokenRepository: TokenRepositoryInterface

  public init(
    localStorage: LocalStorageInterface,
    tokenRepository: TokenRepositoryInterface
  ) {
    self.localStorage = localStorage
    self.tokenRepository = tokenRepository
  }

  public func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    guard urlRequest.url?.absoluteString.hasPrefix("https://dev.moneymong.site/") == true,
          let accessToken = localStorage.accessToken else {
      completion(.success(urlRequest))
      return
    }
    
    // 로그인
    if urlRequest.url?.absoluteString.hasSuffix("/users") == true {
      completion(.success(urlRequest))
      return
    }
    
    // 로그아웃
    if urlRequest.url?.absoluteString.hasSuffix("/tokens") == true {
      completion(.success(urlRequest))
      return
    }
    
    // 토큰 재발급
    if urlRequest.url?.absoluteString.hasSuffix("/tokens") == true {
      completion(.success(urlRequest))
      return
    }
    
    //OCR
    if urlRequest.url?.absoluteString.hasSuffix("/document/receipt") == true {
      completion(.success(urlRequest))
      return
    }

    var urlRequest = urlRequest
    urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
    completion(.success(urlRequest))
  }

  public func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    guard let response = request.task?.response as? HTTPURLResponse,
          response.statusCode == 401 else {
      completion(.doNotRetryWithError(error))
      return
    }
    Task {
      do {
        let token = try await tokenRepository.token()
        localStorage.accessToken = token.accessToken
        localStorage.refreshToken = token.refreshToken
        completion(.retry)
      } catch {
        localStorage.removeAll()
        completion(.doNotRetryWithError(error))
        
        NotificationCenter.default.post(
          name: Notification.Name("appRestart"),
          object: self,
          userInfo: ["message": "로그인이 필요합니다."]
        )
      }
    }
  }
}
