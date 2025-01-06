import Foundation

import Core
import AgencyInterface

public struct ChangeMemberRoleUseCase: ChangeMemberRoleUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int, userId: Int, role: String) async throws {
    try await repo.changeMemberRole(id: id, userId: userId, role: role)
  }
}
