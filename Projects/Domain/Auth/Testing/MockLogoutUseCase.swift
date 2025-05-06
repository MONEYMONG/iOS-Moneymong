import AuthInterface
import BaseDomain

public struct MockLogoutUseCase: LogoutUseCaseInterface {
  public init() {}
  
  public func execute() async throws {}
}
