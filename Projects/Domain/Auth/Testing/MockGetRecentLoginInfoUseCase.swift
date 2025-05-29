import AuthInterface
import BaseDomain

public struct MockGetRecentLoginInfoUseCase: GetRecentLoginInfoUseCaseInterface {
  public init() {}
  
  public func execute() -> LoginType? {
    .kakao
  }
}
