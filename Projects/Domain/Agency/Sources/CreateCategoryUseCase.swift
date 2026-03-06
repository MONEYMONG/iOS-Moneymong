import Foundation

import AgencyInterface
import BaseDomain
import Utility

public struct CreateCategoryUseCase: CreateCategoryUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(agencyId: Int, name: String) async throws {
    if name.components(separatedBy: " ").joined() == "카테고리없음" {
      throw MoneyMongError.default("사용할 수 없는 카테고리 이름이에요")
    }
    
    try await repo.createCategory(agencyId: agencyId, name: name)
  }
}
