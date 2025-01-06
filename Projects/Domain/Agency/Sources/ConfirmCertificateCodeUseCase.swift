import Foundation

import Core
import AgencyInterface

public struct ConfirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  
  public init(repo: AgencyRepositoryInterface) {
    self.repo = repo
  }
  
  public func execute(id: Int, code: String) async throws -> Bool {
    try await repo.certificateCode(id: id, code: code)
  }
}
