import Foundation

import BaseDomain
import LedgerInterface

public struct GetLedgerListUseCase: GetLedgerListUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  private let widgetRefreshController: WidgetRefreshable
  
  public init(ledgerRepo: LedgerRepositoryInterface, widgetRefreshController: WidgetRefreshable) {
    self.ledgerRepo = ledgerRepo
    self.widgetRefreshController = widgetRefreshController
  }
  
  public func excute(id: Int, start: DateInfo, end: DateInfo, page: Int, limit: Int, fundType: FundType?) async throws -> LedgerList {
    defer {
      widgetRefreshController.refresh()
    }
    return try await ledgerRepo.fetchLedgerList(id: id, start: start, end: end, page: page, limit: limit, fundType: fundType)
  }
}
