import Core
import UserInterface

public struct GetMyInfoUseCase: GetMyInfoUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  public func execute() async throws -> UserInfo {
    try await userRepo.user()
  }
}
