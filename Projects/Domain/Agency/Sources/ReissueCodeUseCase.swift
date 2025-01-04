import Foundation

import Core
import AgencyInterface

public struct ConfirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(id: Int) async throws -> String {
    try await repo.reissueCode(id: id)
  }
}
