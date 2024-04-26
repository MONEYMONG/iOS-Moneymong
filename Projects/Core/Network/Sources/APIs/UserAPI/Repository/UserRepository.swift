import Foundation
import Alamofire

public protocol UserRepositoryInterface {
  func user() async throws -> UserInfo
  func logout() async throws
}

public final class UserRepository: UserRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae = NetworkManager()) {
    self.networkManager = networkManager
  }

  public func user() async throws -> UserInfo {
    let targetType = UserAPI.user
    let dto = try await networkManager.request(target: targetType, of: UserResponseDTO.self)
    return dto.toEntity
  }
  
  public func logout() async throws {
    let targetType = UserAPI.logout
    let dto = try await networkManager.request(target: targetType, of: LogoutResponseDTO.self)
    print(dto.toEntity)
    // TODO: Update RefreshToken (Storage)
  }
}
