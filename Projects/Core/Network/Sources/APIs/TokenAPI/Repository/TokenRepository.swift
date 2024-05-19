import Foundation
import Alamofire
import LocalStorage

public protocol TokenRepositoryInterface {
  func token() async throws -> Token
}

public final class TokenRepository: TokenRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }

  // 저장된 refreshToken 없을 경우 처리해줘야함
  public func token() async throws -> Token {
    let refreshToken = localStorage.refreshToken ?? ""
    let targetType = TokenAPI.token(refreshToken: refreshToken)
    let dto = try await networkManager.request(target: targetType, of: TokenResponseDTO.self)
    return dto.toEntity
  }
}
