import AuthInterface
import BaseDomain

public struct SignUpUseCase: SignUpUseCaseInterface {
  private let signRepo: SignRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  public init(signRepo: SignRepositoryInterface, userRepo: UserRepositoryInterface) {
    self.signRepo = signRepo
    self.userRepo = userRepo
  }
  
  public func execute(loginType: LoginType) async throws -> SignInfo {
    let signInfo: SignInfo
    switch loginType {
    case .kakao:
      let authInfo = try await signRepo.kakaoSign()
      signInfo = try await signRepo.sign(
        provider: loginType.value,
        accessToken: authInfo.accessToken,
        name: nil,
        code: nil
      )
    case .apple:
      let authInfo = try await signRepo.appleSign()
      signInfo = try await signRepo.sign(
        provider: loginType.value,
        accessToken: authInfo.idToken,
        name: authInfo.name,
        code: authInfo.authorizationCode
      )
    }
    _ = try await userRepo.user()
    return signInfo
  }
}
