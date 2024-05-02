import Foundation

import LocalStorage

public protocol UserRepositoryInterface {
  func user() async throws -> UserInfo
  func logout() async throws
  func withdrawl() async throws
}

public final class UserRepository: UserRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }

  /// Get: 내정보조회
  public func user() async throws -> UserInfo {
    let targetType = UserAPI.user
    let dto = try await networkManager.request(target: targetType, of: UserResponseDTO.self)
    return dto.toEntity
  }
  
  /// Delete: 로그아웃
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
  
  /// Delete: 회원탈퇴
  public func withdrawl() async throws {
    let targetType = UserAPI.withdrawl
    try await networkManager.request(target: targetType)
    
    localStorage.delete(to: .refreshToken)
    localStorage.delete(to: .accessToken)
    localStorage.delete(to: .socialAccessToken)
    localStorage.delete(to: .recentLoginType)
  }
}
