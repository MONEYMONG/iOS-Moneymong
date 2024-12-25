import AuthInterface
import Core

public struct SignUpUseCase: SignUpUseCaseInterface {
  private let signRepo: SignRepositoryInterface
  
  public init(signRepo: SignRepositoryInterface) {
    self.signRepo = signRepo
  }
  
  public func execute(loginType: LoginType) async throws -> SignInfo {
    switch loginType {
    case .kakao:
      let authInfo = try await signRepo.kakaoSign()
      return try await signRepo.sign(
        provider: loginType.value,
        accessToken: authInfo.accessToken,
        name: nil,
        code: nil
      )
    case .apple:
      let authInfo = try await signRepo.appleSign()
      return try await signRepo.sign(
        provider: loginType.value,
        accessToken: authInfo.idToken,
        name: authInfo.name,
        code: authInfo.authorizationCode
      )
    }
  }
}
