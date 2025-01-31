import Foundation

import AgencyInterface
import BaseDomain

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
  
  public func execute(id: Int?) async throws -> Agency? {
    defer {
      widgetRefreshController.refresh()
    }
    guard let id else {
      throw MoneyMongError.appError(.default, errorMessage: "소속을 삭제할 수 없습니다\n잠시 후 다시 시도해 주세요")
    }
    try await agencyRepo.deleteAgency(id: id)
    let newAgency = try await agencyRepo.fetchMyAgency().first
    userRepo.updateSelectedAgency(id: newAgency?.id)
    return newAgency
  }
}
