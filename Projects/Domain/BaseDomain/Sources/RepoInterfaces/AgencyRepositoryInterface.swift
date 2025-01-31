public protocol AgencyRepositoryInterface {
  func fetchList(page: Int, size: Int) async throws -> [Agency]
  func search(query: String) async throws -> [Agency]
  func create(name: String, type: String) async throws -> Int
  func fetchMemberList(id: Int) async throws -> [Member]
  func changeMemberRole(id: Int, userId: Int, role: String) async throws
  func kickoutMember(id: Int, userId: Int) async throws
  func fetchMyAgency() async throws -> [Agency]
  func fetchCode(id: Int) async throws -> String
  func certificateCode(id: Int, code: String) async throws -> Bool
  func reissueCode(id: Int) async throws -> String
  func deleteAgency(id: Int) async throws
}
