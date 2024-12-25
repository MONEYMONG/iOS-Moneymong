import Core

public protocol GetMyInfoUseCaseInterface {
  func execute() async throws -> UserInfo
}

