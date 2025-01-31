import BaseDomain

public protocol GetMyInfoUseCaseInterface {
  func execute() async throws -> UserInfo
}

