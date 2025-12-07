import Foundation

import AgencyInterface
import BaseDomain

public struct GetCategoriesUseCase: GetCategoriesUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int) async throws -> [MMCategory] {
    return try await repo.getCategories(id: id)
  }
}
