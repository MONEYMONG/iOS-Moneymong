import Foundation

import Core
import AgencyInterface

public struct KickoutMemberUseCase: KickoutMemberUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int, userId: Int) async throws {
    try await repo.kickoutMember(id: id, userId: userId)
  }
}
