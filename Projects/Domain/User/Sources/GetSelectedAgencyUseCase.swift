import BaseDomain
import UserInterface

public struct GetSelectedAgencyUseCase: GetSelectedAgencyUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  public func execute() -> Int? {
    userRepo.fetchSelectedAgency()
  }
}
