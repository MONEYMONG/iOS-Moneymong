import Foundation

import Core
import AgencyInterface

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
  
  public func execute(id: Int, code: [String]) async throws -> Bool {
    let codes = code.compactMap { $0 }.map { String($0) }.joined()
    
    let result = try await agencyRepo.certificateCode(id: id, code: codes)
    if result {
      userRepo.updateSelectedAgency(id: id)
    }
    return result
  }
}
