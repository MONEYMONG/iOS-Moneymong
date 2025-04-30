import AgencyInterface
import BaseDomain

public struct MockGetInvitationCodeUseCase: GetInvitationCodeUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws -> String {
    "Test"
  }
}
