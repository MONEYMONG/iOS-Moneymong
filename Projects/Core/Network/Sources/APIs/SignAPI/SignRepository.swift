import Foundation
import Moya

public protocol SignRepositoryInterface {
  func sign(provider: String, accessToken: String) async throws -> SignInfo
}

public final class SignRepository: SignRepositoryInterface {
  private let provider: MoyaProvider<SignAPI>

  public init(provider: MoyaProvider<SignAPI> = MoyaProvider<SignAPI>()) {
    self.provider = provider
  }

  public func sign(provider: String, accessToken: String) async throws -> SignInfo {
    let request = SignRequestDTO(provider: provider, accessToken: accessToken)
    let response = try await self.provider
      .request(target: .sign(request))
      .map(\.data)
      .decode(GenericResponse<SignResponseDTO>.self)

    guard let data = response.data else {
      throw MoneyMongError.serverError(errorMessage: "response nil")
    }

    return data.toEntity
  }
}


public struct SignRequestDTO: Encodable {
  let provider: String
  let accessToken: String
}

public struct SignResponseDTO: Decodable {
  public let accessToken: String?
  public let refreshToken: String?
  public let loginSuccess: Bool?
  public let schoolInfoExist: Bool?

  public init(accessToken: String?, refreshToken: String?, loginSuccess: Bool?, schoolInfoExist: Bool?) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.loginSuccess = loginSuccess
    self.schoolInfoExist = schoolInfoExist
  }

  public var toEntity: SignInfo {
    .init(
      accessToken: accessToken ?? "",
      refreshToken: refreshToken ?? "",
      loginSuccess: loginSuccess ?? false,
      schoolInfoExist: schoolInfoExist ?? false
    )
  }
}

public struct SignInfo: Decodable {
  public let accessToken: String
  public let refreshToken: String
  public let loginSuccess: Bool
  public let schoolInfoExist: Bool
}

public struct GenericResponse<T: Decodable>: Decodable {
  let data: T?
}
