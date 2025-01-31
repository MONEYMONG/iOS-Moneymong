import Foundation

import AgencyInterface
import BaseDomain

public struct KickoutMemberUseCase: KickoutMemberUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int, userId: Int) async throws -> [Member] {
    try await repo.kickoutMember(id: id, userId: userId)
    return try await repo.fetchMemberList(id: id)
  }
}
