import Foundation
import NetworkService
import Moya

public protocol SignRepositoryInterface {
  func sign(provider: String, accessToken: String) async throws -> SignModelResponseDTO
}

public final class SignRepository: SignRepositoryInterface {
  private let provider: MoyaProvider<SignAPI>

  public init(provider: MoyaProvider<SignAPI> = MoyaProvider<SignAPI>()) {
    self.provider = provider
  }

  public func sign(provider: String, accessToken: String) async throws -> SignModelResponseDTO {
    let request = SignModelRequestDTO(provider: provider, accessToken: accessToken)
    let response = try await self.provider
      .request(target: .sign(request))
      .map(\.data)
      .decode(GenericResponse<SignModelResponseDTO>.self)

    guard let data = response.data else {
      throw MoneyMongError.serverError(errorMessage: "response nil")
    }

    return data
  }
}
