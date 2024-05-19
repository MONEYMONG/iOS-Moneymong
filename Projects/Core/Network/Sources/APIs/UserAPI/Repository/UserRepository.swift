import Foundation

import LocalStorage 

public protocol UserRepositoryInterface {
  func user() async throws -> UserInfo
  func fetchUserID() -> Int
  func fetchSelectedAgency() -> Int?
  func updateSelectedAgency(id: Int)
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
    
    localStorage.userID = dto.id
    
    return dto.toEntity
  }
  
  public func fetchUserID() -> Int {
    return localStorage.userID!
  }
  
  /// Local: 선택된 소속 id가져오기
  public func fetchSelectedAgency() -> Int? {
    return localStorage.selectedAgency
  }
  
  /// Local: 선택된 소속 id 저장하기
  public func updateSelectedAgency(id: Int) {
    localStorage.selectedAgency = id
  }
  
  /// Delete: 로그아웃
  public func logout() async throws {
    guard let refreshToken = localStorage.refreshToken else {
      return debugPrint("Refresh Token이 없음")
    }
    
    let targetType = UserAPI.logout(.init(refreshToken: refreshToken))
    try await networkManager.request(target: targetType)
    
    localStorage.refreshToken = nil
    localStorage.accessToken = nil
    localStorage.socialAccessToken = nil
    localStorage.userID = nil
    localStorage.selectedAgency = nil
  }
  
  /// Delete: 회원탈퇴
  public func withdrawl() async throws {
    let targetType = UserAPI.withdrawl
    try await networkManager.request(target: targetType)
    
    localStorage.refreshToken = nil
    localStorage.accessToken = nil
    localStorage.socialAccessToken = nil
    localStorage.recentLoginType = nil
    localStorage.userID = nil
    localStorage.selectedAgency = nil
  }
}
