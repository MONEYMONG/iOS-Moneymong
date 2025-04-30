import AgencyInterface
import BaseDomain

public struct MockDeleteAgencyUseCase: DeleteAgencyUseCaseInterface {
  public init() {}
  
  public func execute(id: Int?) async throws -> BaseDomain.Agency? {
    nil
  }
}
