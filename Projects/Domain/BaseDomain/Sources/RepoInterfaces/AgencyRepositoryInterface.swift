public protocol AgencyRepositoryInterface {
  func create(name: String) async throws -> Int
  func fetchMemberList(id: Int) async throws -> [Member]
  func changeMemberRole(id: Int, userId: Int, role: String) async throws
  func kickoutMember(id: Int, userId: Int) async throws
  func fetchMyAgency() async throws -> [Agency]
  func fetchCode(id: Int) async throws -> String
  func certificateCode(code: String) async throws -> CertificationResult
  func reissueCode(id: Int) async throws -> String
  func deleteAgency(id: Int) async throws
  func getCategories(id: Int) async throws -> [MMCategory]
  func createCategory(agencyId: Int, name: String) async throws
  func deleteCategory(id: Int) async throws
}
