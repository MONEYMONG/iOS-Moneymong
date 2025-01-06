import Foundation

import Core
import AgencyInterface

public struct ChangeMemberRoleUseCase: ChangeMemberRoleUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(id: Int, userId: Int, role: String) async throws {
    try await repo.changeMemberRole(id: id, userId: userId, role: role)
  }
}
