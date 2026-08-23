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
    } else {
      // 소속에 가입되어 있는 않는 경우
      let response = try await agencyRepo.certificateCode(code: code)
      if response.certified {
        userRepo.updateSelectedAgency(id: response.agencyId)
        return agencies.first { $0.id == response.agencyId }
      }
    }
    
    return nil
  }
}
