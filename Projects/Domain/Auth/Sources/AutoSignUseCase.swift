import AuthInterface
import Core

public struct AutoSignUseCase: AutoSignUseCaseInterface {
  private let userRepo: UserRepositoryInterface
  private let versionRepo: VersionRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface, versionRepo: VersionRepositoryInterface) {
    self.userRepo = userRepo
    self.versionRepo = versionRepo
  }
  
  public func execute() async throws {
    try await versionRepo.get()
    _ = try await userRepo.user()
  }
}
