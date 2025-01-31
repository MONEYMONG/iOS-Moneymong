import BaseDomain
import UserInterface

public struct UpdateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  public func execute(id: Int) {
    userRepo.updateSelectedAgency(id: id)
  }
}
