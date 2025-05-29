import AuthInterface
import BaseDomain

public struct MockDeleteUserUseCase: DeleteUserUseCaseInterface {
  public init() {}
  
  public func execute() async throws { print(#file) }
}
