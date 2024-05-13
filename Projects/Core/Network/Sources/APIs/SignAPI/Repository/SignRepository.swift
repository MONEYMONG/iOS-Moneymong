import Foundation
import Alamofire

import LocalStorage

public protocol SignRepositoryInterface {
  func autoSign() async throws -> SignInfo
  func kakaoSign() async throws -> KakaoAuthInfo
  func appleSign() async throws -> AppleAuthInfo
  func sign(
    provider: String,
    accessToken: String,
    name: String?,
    code: String?
  ) async throws -> SignInfo
  func recentLoginType() -> LoginType?
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

  public func recentLoginType() -> LoginType? {
    guard let loginType = localStorage.read(to: .recentLoginType)?.lowercased(),
          let recentLoginType = LoginType(rawValue: loginType) else {
      return nil
    }
    return recentLoginType
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

  public func autoSign() async throws -> SignInfo {
    guard let provider = localStorage.read(to: .recentLoginType),
          let accessToken = localStorage.read(to: .socialAccessToken) else {
      throw MoneyMongError.unknown("저장된 유저 정보가 없습니다.")
    }

    return try await sign(provider: provider, accessToken: accessToken)
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

    localStorage.create(to: .accessToken, value: entity.accessToken)
    localStorage.create(to: .refreshToken, value: entity.refreshToken)
    localStorage.create(to: .socialAccessToken, value: accessToken)
    localStorage.create(to: .recentLoginType, value: provider)

    return entity
  }

  public func logout() async throws {
    guard let refreshToken = localStorage.read(to: .refreshToken) else {
      return debugPrint("Refresh Token이 없음")
    }
    let targetType = UserAPI.logout(.init(refreshToken: refreshToken))
    try await networkManager.request(target: targetType)

    localStorage.delete(to: .refreshToken)
    localStorage.delete(to: .accessToken)
    localStorage.delete(to: .socialAccessToken)
  }
}
