import Foundation
import Alamofire

public protocol SignRepositoryInterface {
  func sign(provider: String, accessToken: String) async throws -> SignInfo
}

public final class SignRepository: SignRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae = NetworkManager()) {
    self.networkManager = networkManager
  }

  public func sign(provider: String, accessToken: String) async throws -> SignInfo {
    let request = SignRequestDTO(provider: provider, accessToken: accessToken)
    let targetType = SignAPI.sign(request)
    let dto = try await networkManager.request(target: targetType, of: SignResponseDTO.self)

    return dto.toEntity
  }
}
