import AuthInterface
import Utility
public struct MockAutoSignUseCase: AutoSignUseCaseInterface {
  public init() {}
  
  public func execute() async throws {
    throw MoneyMongError.appError(.default)
  }
}
