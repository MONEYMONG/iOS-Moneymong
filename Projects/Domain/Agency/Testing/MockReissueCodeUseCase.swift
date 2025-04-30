import AgencyInterface
import BaseDomain

public struct MockReissueCodeUseCase: ReissueCodeUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws -> String {
    "111111"
  }
}
