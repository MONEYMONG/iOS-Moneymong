import UserInterface
import BaseDomain

public struct MockGetMyInfoUseCase: GetMyInfoUseCaseInterface {
  public init() {}
  
  public func execute() async throws -> BaseDomain.UserInfo {
    .init(id: 0, nickname: "홍길동", email: "asdf@asdf.com", universityName: "", grade: 0, provider: "provider")
  }
}
