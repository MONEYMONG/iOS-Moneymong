import Foundation

public protocol UserRepositoryInterface {
  func user() async throws -> UserInfo
  func logout() async throws
  func withdrawl() async throws
}

public final class UserRepository: UserRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae = NetworkManager()) {
    self.networkManager = networkManager
  }

  /// Get: 내정보조회
  public func user() async throws -> UserInfo {
    let targetType = UserAPI.user
    let dto = try await networkManager.request(target: targetType, of: UserResponseDTO.self)
    return dto.toEntity
  }
  
  /// Delete: 로그아웃
  public func logout() async throws {
    // TODO: RefreshToken 넣어주기
    let targetType = UserAPI.logout(.init(refreshToken: "refreshToken"))
    try await networkManager.request(target: targetType)
    
    // TODO: token전부삭제
  }
  
  /// Delete: 회원탈퇴
  public func withdrawl() async throws {
    let targetType = UserAPI.withdrawl
    try await networkManager.request(target: targetType)
    // TODO: token전부삭제
  }
}
