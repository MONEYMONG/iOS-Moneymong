import Foundation

import AgencyInterface
import BaseDomain
import Utility

public struct MockCreateCategoryUseCase: CreateCategoryUseCaseInterface {
  public init() {}
  
  public func execute(agencyId: Int, name: String) async throws {
    print("create category: \(name)")
    if name.components(separatedBy: " ").joined() == "카테고리없음" {
      throw MoneyMongError.default("사용할 수 없는 카테고리 이름이에요")
    }
  }
}
