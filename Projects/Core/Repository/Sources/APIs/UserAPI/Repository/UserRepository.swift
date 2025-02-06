import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface
import Utility

public struct UserRepository: UserRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface
  private let memoryCache: Cacheable

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface,
    memoryCache: Cacheable
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
    self.memoryCache = memoryCache
  }

  /// Get: 내정보조회
  public func user() async throws -> UserInfo {
    let targetType = UserAPI.user
    let dto = try await networkManager.request(target: targetType, of: UserResponseDTO.self, cache: memoryCache)
    let entity = dto.toEntity

    localStorage.userID = entity.id

    return entity
  }
  
  public func fetchUserID() -> Int {
    return localStorage.userID!
  }
  
  /// Local: 선택된 소속 id가져오기
  public func fetchSelectedAgency() -> Int? {
    return localStorage.selectedAgency
  }
  
  /// Local: 선택된 소속 id 저장하기
  public func updateSelectedAgency(id: Int?) {
    localStorage.selectedAgency = id
  }
  
  /// Delete: 로그아웃
  public func logout() async throws {
    guard let refreshToken = localStorage.refreshToken else {
      return debugPrint("Refresh Token이 없음")
    }
    
    let targetType = UserAPI.logout(.init(refreshToken: refreshToken))
    try await networkManager.request(target: targetType)
    FirebaseManager.shared.logEvent(event: .logout, parameters: ["user_id" : localStorage.userID ?? "unknown"])
    memoryCache.deleteAll()
    localStorage.removeAll()
  }
  
  /// Delete: 회원탈퇴
  public func withdrawl() async throws {
    let targetType = UserAPI.withdrawl
    try await networkManager.request(target: targetType)
    FirebaseManager.shared.logEvent(event: .deleteAccount, parameters: ["user_id" : localStorage.userID ?? "unknown"])
    localStorage.removeAll()
    memoryCache.deleteAll()
  }
}
