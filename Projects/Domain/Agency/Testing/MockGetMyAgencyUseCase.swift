import AgencyInterface
import BaseDomain

public struct MockGetMyAgencyUseCase: GetMyAgencyUseCaseInterface {
  public init() {}
  
  public func execute() async throws -> [BaseDomain.Agency] {
    return [
      Agency(id: 0, name: "Test0", count: 0, type: .general),
      Agency(id: 1, name: "Test1", count: 0, type: .general),
      Agency(id: 2, name: "Test2", count: 0, type: .general),
      Agency(id: 3, name: "Test3", count: 0, type: .general),
      Agency(id: 4, name: "Test4", count: 0, type: .general),
      Agency(id: 5, name: "Test5", count: 0, type: .general),
    ]
  }
}
