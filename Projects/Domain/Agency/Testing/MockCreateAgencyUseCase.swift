import AgencyInterface
import BaseDomain

public struct MockCreateAgencyUseCase: CreateAgencyUseCaseInterface {
  public init() {}
  
  public func execute(name: String) async throws -> Int { 0 }
}
