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
}
