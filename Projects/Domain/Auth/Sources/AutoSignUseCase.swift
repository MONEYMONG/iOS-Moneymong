import AuthInterface
import Core

public struct AutoSignUseCase: AutoSignUseCaseInterface {
  private let signRepo: SignRepositoryInterface
  private let versionRepo: VersionRepositoryInterface
  
  public init(signRepo: SignRepositoryInterface, versionRepo: VersionRepositoryInterface) {
    self.signRepo = signRepo
    self.versionRepo = versionRepo
  }
  
  public func execute() async throws -> SignInfo {
    try await versionRepo.get()
    return try await signRepo.autoSign()
  }
}
