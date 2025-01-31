import AuthInterface
import BaseDomain

public struct LogoutUseCase: LogoutUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  public func execute() async throws {
    try await userRepo.logout()
  }
}
