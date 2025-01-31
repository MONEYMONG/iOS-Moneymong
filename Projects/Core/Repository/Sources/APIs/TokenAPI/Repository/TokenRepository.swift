import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface

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
  public func token() async throws {
    let request = RefreshTokenRequestDTO(refreshToken: localStorage.refreshToken ?? "")
    let targetType = TokenAPI.token(request)
    let token = try await networkManager.request(target: targetType, of: TokenResponseDTO.self).toEntity
    localStorage.accessToken = token.accessToken
    localStorage.refreshToken = token.refreshToken
  }
}
