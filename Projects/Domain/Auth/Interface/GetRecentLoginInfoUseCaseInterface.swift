import BaseDomain

public protocol GetRecentLoginInfoUseCaseInterface {
  func execute() -> LoginType?
}
