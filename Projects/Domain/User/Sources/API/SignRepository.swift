import Foundation
import Network
import Moya

public protocol SignRepositoryInterface {

}

public final class SignRepository: SignRepositoryInterface {
  private let provider: MoyaProvider<SignAPI>

  public init(provider: MoyaProvider<SignAPI> = MoyaProvider<SignAPI>()) {
    self.provider = provider
  }

  public func postSign(provider: String, accessToken: String) async throws -> SignModelResponseDTO {
    let request = SignModelRequestDTO(provider: provider, accessToken: accessToken)
    let response = try await self.provider
      .request(target: .sign(request))
      .map(\.data)
      .decode(SignModelResponseDTO.self)

    return response
  }
}
