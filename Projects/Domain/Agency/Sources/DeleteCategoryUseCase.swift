import Foundation

import AgencyInterface
import BaseDomain

public struct DeleteCategoryUseCase: DeleteCategoryUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int) async throws {
    return try await repo.deleteCategory(id: id)
  }
}
