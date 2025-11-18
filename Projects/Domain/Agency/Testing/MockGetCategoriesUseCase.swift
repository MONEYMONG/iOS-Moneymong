import AgencyInterface
import BaseDomain

public struct MockGetCategoriesUseCase: GetCategoriesUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws -> [String] {
    return ["회비", "식비", "운용비", "공과금", "학비", "장학금", "재산금", "장기예산", "기타"]
  }
}
