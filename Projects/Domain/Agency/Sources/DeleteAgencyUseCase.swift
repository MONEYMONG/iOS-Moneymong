import Foundation

import Core
import AgencyInterface

public struct DeleteAgencyUseCase: DeleteAgencyUseCaseInterface {
  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let widgetRefreshController: WidgetRefreshable
  
  public init(
    agencyRepo: AgencyRepositoryInterface,
    userRepo: UserRepositoryInterface,
    widgetRefreshController: WidgetRefreshable
  ) {
    self.agencyRepo = agencyRepo
    self.userRepo = userRepo
    self.widgetRefreshController = widgetRefreshController
  }
  
  public func execute(id: Int) async throws -> Agency? {
    defer {
      widgetRefreshController.refresh()
    }
    try await agencyRepo.deleteAgency(id: id)
    let newAgency = try await agencyRepo.fetchMyAgency().first
    userRepo.updateSelectedAgency(id: newAgency?.id)
    return newAgency
  }
}
