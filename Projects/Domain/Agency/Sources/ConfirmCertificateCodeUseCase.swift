import Foundation

import AgencyInterface
import BaseDomain

public struct ConfirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface {
  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  public init(
    agencyRepo: AgencyRepositoryInterface,
    userRepo: UserRepositoryInterface
  ) {
    self.agencyRepo = agencyRepo
    self.userRepo = userRepo
  }
  
  public func execute(code: [String]) async throws -> Agency? {
    let codes = code.compactMap { $0 }.map { String($0) }.joined()
    
    let response = try await agencyRepo.certificateCode(code: codes)
    if response.certified {
      userRepo.updateSelectedAgency(id: response.agencyId)
      return try await agencyRepo.fetchMyAgency().first { $0.id == response.agencyId }
    }
    return nil
  }
  
  public func execute(code: String, agencyID: Int) async throws -> Agency? {
    let agencies = try await agencyRepo.fetchMyAgency()
    if let agency = agencies.first(where: { $0.id == agencyID }) {
      // 이미 소속에 가입되어 있는 경우
      userRepo.updateSelectedAgency(id: agencyID)
      return agency
    }

    // 소속에 가입되어 있지 않은 경우
    let response = try await agencyRepo.certificateCode(code: code)
    guard response.certified else { return nil }

    userRepo.updateSelectedAgency(id: response.agencyId)
    // 방금 가입했으므로 가입 전 조회한 `agencies`(stale)가 아니라 재조회한 목록에서 찾는다.
    return try await agencyRepo.fetchMyAgency().first { $0.id == response.agencyId }
  }
}
