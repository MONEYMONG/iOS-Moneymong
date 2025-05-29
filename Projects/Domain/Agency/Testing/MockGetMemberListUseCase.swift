import AgencyInterface
import BaseDomain

public struct MockGetMemberListUseCase: GetMemberListUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws -> [Member] {
    [.init(agencyID: 0, userID: 0, nickname: "홍길동", role: .staff)]
  }
}
