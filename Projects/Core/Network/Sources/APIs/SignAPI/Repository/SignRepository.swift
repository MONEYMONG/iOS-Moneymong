import Foundation
import Alamofire

import LocalStorage

public protocol SignRepositoryInterface {
  func sign(provider: String, accessToken: String) async throws -> SignInfo
  func kakaoSign() async throws -> String
  func appleSign() async throws -> String
}

public final class SignRepository: SignRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  private let kakaoAuthManager: KakaoAuthManager
  private let appleAuthManager: AppleAuthManager

  public init(
    networkManager: NetworkManagerInterfacae = NetworkManager(),
    localStorage: LocalStorageInterface = LocalStorageManager(),
    kakaoAuthManager: KakaoAuthManager = .shared,
    appleAuthManager: AppleAuthManager = AppleAuthManager()
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
    self.kakaoAuthManager = kakaoAuthManager
    self.appleAuthManager = appleAuthManager
  }

  public func kakaoSign() async throws -> String {
    do {
      return try await kakaoAuthManager.sign()
    } catch {
      throw MoneyMongError.unknown(error.localizedDescription)
    }
  }

  public func appleSign() async throws -> String {
    do {
      return try await appleAuthManager.sign()
    } catch {
      throw MoneyMongError.unknown(error.localizedDescription)
    }
  }

  public func sign(provider: String, accessToken: String) async throws -> SignInfo {
    let request = SignRequestDTO(provider: provider, accessToken: accessToken)
    let targetType = SignAPI.sign(request)
    let dto = try await networkManager.request(target: targetType, of: SignResponseDTO.self)
    let entity = dto.toEntity

    localStorage.create(to: .accessToken, value: entity.accessToken)
    localStorage.create(to: .refreshToken, value: entity.refreshToken)
    localStorage.create(to: .recentLoginType, value: provider)

    return entity
  }
}
