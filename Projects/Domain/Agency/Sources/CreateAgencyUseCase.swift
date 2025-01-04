import Foundation

import Core
import AgencyInterface

public struct CreateAgencyUseCase: CreateAgencyUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(name: String, type: String) async throws -> Int {
    try await repo.create(name: name, type: type)
  }
}
