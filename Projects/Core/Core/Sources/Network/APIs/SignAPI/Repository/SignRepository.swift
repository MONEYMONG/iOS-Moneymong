import Foundation
import Alamofire

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
    localStorage: LocalStorageInterface = LocalStorage(),
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

  public func autoSign() async throws -> SignInfo {
    guard let provider = localStorage.recentLoginType,
          let accessToken = localStorage.socialAccessToken
    else {
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

    localStorage.accessToken = entity.accessToken
    localStorage.refreshToken = entity.refreshToken
    localStorage.socialAccessToken = accessToken
    localStorage.recentLoginType = provider

    return entity
  }

  public func logout() async throws {
    guard let refreshToken = localStorage.refreshToken else {
      return debugPrint("Refresh Token이 없음")
    }
    
    let targetType = UserAPI.logout(.init(refreshToken: refreshToken))
    try await networkManager.request(target: targetType)

    localStorage.refreshToken = nil
    localStorage.accessToken = nil
    localStorage.socialAccessToken = nil
  }
}
