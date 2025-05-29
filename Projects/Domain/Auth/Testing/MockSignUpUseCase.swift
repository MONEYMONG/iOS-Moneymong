import AuthInterface
import BaseDomain

public struct MockSignUpUseCase: SignUpUseCaseInterface {
  public init() {}
  
  public func execute(loginType: LoginType) async throws -> SignInfo {
    SignInfo(
      accessToken: "test-token",
      refreshToken: "test-token",
      loginSuccess: true,
      schoolInfoExist: false,
      schoolInfoProvided: false
    )
  }
}
