import Foundation

import Core
import AgencyInterface

public struct GetMemberListUseCase: GetMemberListUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(id: Int) async throws -> [Member] {
    try await repo.fetchMemberList(id: id)
  }
}
