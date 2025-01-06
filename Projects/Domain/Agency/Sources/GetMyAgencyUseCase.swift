import Foundation

import Core
import AgencyInterface

public struct GetMyAgencyUseCase: GetMyAgencyUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute() async throws -> [Agency] {
    try await repo.fetchMyAgency()
  }
}
