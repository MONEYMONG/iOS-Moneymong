import Foundation

import BaseDomain
import MMNetworkInterface
import MMStorageInterface

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
    return try await networkManager.request(target: targetType, of: AgencyIDResponseDTO.self).id
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
    localStorage.deleteCurrentLedgerInfo()
  }
}
