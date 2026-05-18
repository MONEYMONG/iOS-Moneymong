import AgencyInterface
import BaseDomain

public struct MockGetMemberListUseCase: GetMemberListUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws -> [Member] {
    [.init(agencyID: 0, userID: 0, nickname: "홍길동", role: .staff),
     .init(agencyID: 0, userID: 1, nickname: "장발장", role: .member)]
  }
}
