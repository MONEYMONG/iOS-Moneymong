import Foundation

public protocol UserRepositoryInterface {
  func user() async throws -> UserInfo
  func fetchUserID() -> Int
  func fetchSelectedAgency() -> Int?
  func updateSelectedAgency(id: Int?)
  func logout() async throws
  func withdrawl() async throws
}

public final class UserRepository: UserRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface
  private let memoryCache: Cacheable

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface,
    memoryCache: Cacheable = MemoryCache.shared
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
    FirebaseManager.shared.setUser(id: "\(entity.id)")

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
    
    localStorage.refreshToken = nil
    localStorage.accessToken = nil
    localStorage.socialAccessToken = nil
    localStorage.userID = nil
    localStorage.selectedAgency = nil
    memoryCache.deleteAll()
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
    memoryCache.deleteAll()
  }
}
