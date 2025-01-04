import Foundation

import Core
import AgencyInterface

public struct GetInvitationCodeUseCase: GetInvitationCodeUseCaseInterface {
  
  private let repo: AgencyRepositoryInterface
  
  public func execute(id: Int) async throws -> String {
    try await repo.fetchCode(id: id)
  }
}
