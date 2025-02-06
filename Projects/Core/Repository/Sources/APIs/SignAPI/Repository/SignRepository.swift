import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface
import Utility

public struct SignRepository: SignRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  private let kakaoAuthManager: KakaoAuthManager
  private let appleAuthManager: AppleAuthManager

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface,
    kakaoAuthManager: KakaoAuthManager = .shared,
    appleAuthManager: AppleAuthManager = AppleAuthManager()
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
    self.kakaoAuthManager = kakaoAuthManager
    self.appleAuthManager = appleAuthManager
  }

  public func recentLoginType() -> LoginType? {
    guard let loginType = localStorage.recentLoginType else { return nil }
    return LoginType(rawValue: loginType.lowercased())
  }

  public func kakaoSign() async throws -> KakaoAuthInfo {
    do {
      return try await kakaoAuthManager.sign()
    } catch {
      throw MoneyMongError.unknown(error.localizedDescription)
    }
  }

  public func appleSign() async throws -> AppleAuthInfo {
    do {
      return try await appleAuthManager.sign()
    } catch {
      throw MoneyMongError.unknown(error.localizedDescription)
    }
  }

  public func sign(
    provider: String,
    accessToken: String,
    name: String? = nil,
    code: String? = nil
  ) async throws -> SignInfo {
    let request = SignRequestDTO(
      provider: provider,
      accessToken: accessToken,
      name: name,
      code: code
    )
    
    let targetType = SignAPI.sign(request)
    let dto = try await networkManager.request(target: targetType, of: SignResponseDTO.self)
    let entity = dto.toEntity

    localStorage.accessToken = entity.accessToken
    localStorage.refreshToken = entity.refreshToken
    localStorage.socialAccessToken = accessToken
    localStorage.recentLoginType = provider

    return entity
  }
}
