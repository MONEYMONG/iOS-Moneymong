import AgencyInterface
import BaseDomain

public struct MockKickoutMemberUseCase: KickoutMemberUseCaseInterface {
  public init() {}
  
  public func execute(id: Int, userId: Int) async throws -> [BaseDomain.Member] {
    []
  }
}
