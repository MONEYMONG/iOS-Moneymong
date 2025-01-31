import AuthInterface
import BaseDomain

public struct DeleteUserUseCase: DeleteUserUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  public func execute() async throws {
    try await userRepo.withdrawl()
  }
}
