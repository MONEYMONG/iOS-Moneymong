public protocol UserRepositoryInterface {
  func user() async throws -> UserInfo
  func fetchUserID() -> Int
  func fetchSelectedAgency() -> Int?
  func updateSelectedAgency(id: Int?)
  func logout() async throws
  func withdrawl() async throws
}
