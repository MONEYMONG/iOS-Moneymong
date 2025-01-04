import Foundation

import Core
import AgencyInterface

public struct GetMyAgencyUseCase: GetMyAgencyUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute() async throws -> [Agency] {
    try await repo.fetchMyAgency()
  }
}
