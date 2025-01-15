import AuthInterface
import Core

public struct GetRecentLoginInfoUseCase: GetRecentLoginInfoUseCaseInterface {
  private let signRepo: SignRepositoryInterface
  
  public init(signRepo: SignRepositoryInterface) {
    self.signRepo = signRepo
  }
  
  public func execute() -> LoginType? {
    return signRepo.recentLoginType()
  }
}
