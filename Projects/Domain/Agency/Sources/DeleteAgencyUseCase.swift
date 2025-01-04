import Foundation

import Core
import AgencyInterface

public struct DeleteAgencyUseCase: DeleteAgencyUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(id: Int) async throws {
    try await repo.deleteAgency(id: id)
  }
}
