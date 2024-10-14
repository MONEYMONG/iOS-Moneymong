import Foundation

public protocol VersionRepositoryInterface {
  func get() async throws
}

public final class VersionRepository: VersionRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  
  public init(networkManager: NetworkManagerInterfacae) {
    self.networkManager = networkManager
  }
  
  public func get() async throws {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      let targetType = VersionAPI.version(VersionRequestDTO(version: version))
      try await networkManager.request(target: targetType)
    }
  }
}
