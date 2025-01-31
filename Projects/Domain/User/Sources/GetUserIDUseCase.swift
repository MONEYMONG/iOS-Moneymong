import BaseDomain
import UserInterface

public struct GetUserIDUseCase: GetUserIDUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  public func execute() -> Int {
    userRepo.fetchUserID()
  }
}
