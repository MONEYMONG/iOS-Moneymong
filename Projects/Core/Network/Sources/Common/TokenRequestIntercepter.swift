import Foundation

import LocalStorage
import Alamofire

public final class TokenRequestIntercepter: RequestInterceptor {
  private let localStorage: LocalStorageInterface
  private let tokenRepository: TokenRepositoryInterface

  public init(
    localStorage: LocalStorageInterface = LocalStorageManager(),
    tokenRepository: TokenRepositoryInterface = TokenRepository()
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
          let accessToken = localStorage.read(to: .accessToken) else {
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

    var urlRequest = urlRequest
    urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
    completion(.success(urlRequest))
  }

  public func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) async {
    guard let response = request.task?.response as? HTTPURLResponse,
          response.statusCode == 403 else {
      completion(.doNotRetryWithError(error))
      return
    }

    do {
      let token = try await tokenRepository.token()
      localStorage.create(to: .accessToken, value: token.accessToken)
      localStorage.create(to: .refreshToken, value: token.refreshToken)
      completion(.retry)
    } catch {
      localStorage.delete(to: .accessToken)
      localStorage.delete(to: .refreshToken)
      completion(.doNotRetryWithError(error))
    }
  }
}
