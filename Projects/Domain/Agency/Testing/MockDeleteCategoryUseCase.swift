import AgencyInterface
import BaseDomain

public struct MockDeleteCategoryUseCase: DeleteCategoryUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws {
    print("Delete category with id: \(id)")
  }
}
