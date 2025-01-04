import Foundation

import Core
import AgencyInterface

public struct SearchAgencyUseCase: SearchAgencyUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(query: String) async throws -> [Agency] {
    try await repo.search(query: query)
  }
}
