import Foundation

import Core
import AgencyInterface

public struct DeleteAgencyUseCase: DeleteAgencyUseCaseInterface {
  private let repo: AgencyRepositoryInterface
  private let widgetRefreshController: WidgetRefreshable
  
  public init(repo: AgencyRepositoryInterface, widgetRefreshController: WidgetRefreshable) {
    self.repo = repo
    self.widgetRefreshController = widgetRefreshController
  }
  
  public func execute(id: Int) async throws {
    defer {
      widgetRefreshController.refresh()
    }
    try await repo.deleteAgency(id: id)
  }
}
