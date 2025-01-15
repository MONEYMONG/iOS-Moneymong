import AuthInterface
import Core

public struct AutoSignUseCase: AutoSignUseCaseInterface {
  private let tokenRepo: TokenRepositoryInterface
  private let versionRepo: VersionRepositoryInterface
  
  public init(tokenRepo: TokenRepositoryInterface, versionRepo: VersionRepositoryInterface) {
    self.tokenRepo = tokenRepo
    self.versionRepo = versionRepo
  }
  
  public func execute() async throws {
    try await versionRepo.get()
    return try await tokenRepo.token()
  }
}
