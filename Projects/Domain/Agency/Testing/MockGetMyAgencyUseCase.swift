import AgencyInterface
import BaseDomain

public struct MockGetMyAgencyUseCase: GetMyAgencyUseCaseInterface {
  public init() {}
  
  public func execute() async throws -> [BaseDomain.Agency] {
    return [Agency(id: 0, name: "Test", count: 0, type: .general)]
  }
}
