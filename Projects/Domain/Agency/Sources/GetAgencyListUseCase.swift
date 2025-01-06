import Foundation

import AgencyInterface
import Core

public struct GetAgencyListUseCase: GetAgencyListUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(page: Int, size: Int) async throws -> [Agency] {
    return try await repo.fetchList(page: page, size: size)
  }
}
