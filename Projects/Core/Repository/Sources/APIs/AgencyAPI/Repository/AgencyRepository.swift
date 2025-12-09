import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface
import Utility

public struct AgencyRepository: AgencyRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface
  private let memoryCache: Cacheable

  public init(networkManager: NetworkManagerInterfacae, localStorage: LocalStorageInterface, memoryCache: Cacheable) {
    self.networkManager = networkManager
    self.localStorage = localStorage
    self.memoryCache = memoryCache
  }
  
  public func create(name: String) async throws -> Int {
    let targetType = AgencyAPI.create(param: .init(name: name, agencyType: "GENERAL"))
    let agencyID = try await networkManager.request(target: targetType, of: AgencyIDResponseDTO.self).id
    memoryCache.delete(key: "v1/agencies/me")
    FirebaseManager.shared.logEvent(
      event: .createAgency,
      parameters: [
        "agency_name" : name,
        "agency_id" : agencyID,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
    return agencyID
  }
  
  public func fetchMemberList(id: Int) async throws -> [Member] {
    let targetType = AgencyAPI.memberList(id: id)
    let dto = try await networkManager.request(target: targetType, of: AgencyMemberListResponseDTO.self)
    return dto.toEntity
  }
  
  public func changeMemberRole(id: Int, userId: Int, role: String) async throws {
    let targetType = AgencyAPI.changeRole(id: id, param: .init(userId: userId, role: role))
    try await networkManager.request(target: targetType)
  }
  
  public func kickoutMember(id: Int, userId: Int) async throws {
    let targetType = AgencyAPI.kickout(id: id, param: .init(userId: userId))
    try await networkManager.request(target: targetType)
    FirebaseManager.shared.logEvent(
      event: .kickoutMember,
      parameters: [
        "agency_id" : id,
        "kickout_user_id" : userId,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
  }
  
  public func fetchMyAgency() async throws -> [Agency] {
    let targetType = AgencyAPI.myAgency
    let dto = try await networkManager.request(target: targetType, of: [AgencyResponseDTO].self, cache: memoryCache)
    return dto.toEntity
  }
  
  public func fetchCode(id: Int) async throws -> String {
    let targetType = AgencyAPI.code(id: id)
    let dto = try await networkManager.request(target: targetType, of: InvitationCodeResponseDTO.self)
    return dto.toEntity
  }
  
  public func certificateCode(code: String) async throws -> CertificationResult {
    let targetType = AgencyAPI.certificateCode(param: .init(invitationCode: code))
    let dto = try await networkManager.request(target: targetType, of: CertificateCodeRequestDTO.self)
    memoryCache.delete(key: "v1/agencies/me")
    FirebaseManager.shared.logEvent(
      event: .joinAgency,
      parameters: [
        "code" : code,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
    return dto.toEntity
  }
  
  public func reissueCode(id: Int) async throws -> String {
    let targetType = AgencyAPI.reissueCode(id: id)
    let dto = try await networkManager.request(target: targetType, of: InvitationCodeResponseDTO.self)
    return dto.toEntity
  }
  
  public func deleteAgency(id: Int) async throws {
    let targetType = AgencyAPI.delete(id: id)
    try await networkManager.request(target: targetType)
    FirebaseManager.shared.logEvent(
      event: .deleteAgency,
      parameters: [
        "agency_id" : id,
        "user_id" : localStorage.userID ?? "unknown"
      ]
    )
    localStorage.deleteCurrentLedgerInfo()
    memoryCache.delete(key: "v1/agencies/me")
  }
  
  public func getCategories(id: Int) async throws -> [MMCategory] {
    let targetType = AgencyAPI.getCategories(id: id)
    return try await networkManager.request(target: targetType, of: CategoriesResponseDTO.self).toEntity
  }
  
  public func createCategory(id: Int, name: String) async throws -> String {
    let targetType = AgencyAPI.createCategory(query: CreateCategoryRequestDTO(agencyId: id, name: name))
    try await networkManager.request(target: targetType)
    return name
  }
  
  public func deleteCategory(id: Int) async throws {
    let targetType = AgencyAPI.deleteCategory(id: id)
    try await networkManager.request(target: targetType)
  }
}
