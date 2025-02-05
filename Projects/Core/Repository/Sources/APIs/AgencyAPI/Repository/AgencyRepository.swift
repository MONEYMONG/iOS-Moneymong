import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface
import Utility

public struct AgencyRepository: AgencyRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  public init(networkManager: NetworkManagerInterfacae, localStorage: LocalStorageInterface) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }
  
  public func fetchList(page: Int, size: Int) async throws -> [Agency] {
    let targetType = AgencyAPI.list(param: .init(page: page, size: size, sort: nil))
    let dto = try await networkManager.request(target: targetType, of: AgencyListResponseDTO.self)
    return dto.toEntity
  }
  
  public func search(query: String) async throws -> [Agency] {
    let targetType = AgencyAPI.search(query: query)
    let dto = try await networkManager.request(target: targetType, of: [AgencyResponseDTO].self)
    return dto.toEntity
  }
  
  public func create(name: String, type: String) async throws -> Int {
    let targetType = AgencyAPI.create(param: .init(name: name, agencyType: type))
    let agencyID = try await networkManager.request(target: targetType, of: AgencyIDResponseDTO.self).id
    FirebaseManager.shared.logEvent(
      event: .createAgency,
      parameters: [
        "agency_name" : name,
        "agency_id" : agencyID,
        "agency_type" : type,
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
    let dto = try await networkManager.request(target: targetType, of: [AgencyResponseDTO].self)
    return dto.toEntity
  }
  
  public func fetchCode(id: Int) async throws -> String {
    let targetType = AgencyAPI.code(id: id)
    let dto = try await networkManager.request(target: targetType, of: InvitationCodeResponseDTO.self)
    return dto.toEntity
  }
  
  public func certificateCode(id: Int, code: String) async throws -> Bool {
    let targetType = AgencyAPI.certificateCode(id: id, param: .init(invitationCode: code))
    let dto = try await networkManager.request(target: targetType, of: CertificateCodeRequestDTO.self)
    FirebaseManager.shared.logEvent(
      event: .joinAgency,
      parameters: [
        "agency_id" : id,
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
  }
}
