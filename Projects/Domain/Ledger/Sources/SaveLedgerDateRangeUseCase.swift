import Foundation

import Core
import LedgerInterface

public struct SaveLedgerDateRangeUseCase: SaveLedgerDateRangeUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func excute(dateRange: DateRange) {
    ledgerRepo.saveDateRange(dateRange)
  }
}
