import Foundation

import Core
import AgencyInterface

public struct GetInvitationCodeUseCase: GetInvitationCodeUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int) async throws -> String {
    try await repo.fetchCode(id: id)
  }
}
