import AgencyInterface
import BaseDomain

public struct MockGetCategoriesUseCase: GetCategoriesUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws -> [MMCategory] {
//    return ["회비", "식비", "운용비", "공과금", "학비", "장학금", "재산금", "장기예산", "기타"]
    return [
      MMCategory(id: 1, name: "회비"),
      MMCategory(id: 2, name: "식비"),
      MMCategory(id: 3, name: "운용비"),
      MMCategory(id: 4, name: "공과금"),
      MMCategory(id: 5, name: "학비"),
      MMCategory(id: 6, name: "장학금"),
      MMCategory(id: 7, name: "재산금"),
      MMCategory(id: 8, name: "장기예산"),
      MMCategory(id: 9, name: "기타"),
    ]
  }
}
