import Foundation

import BaseDomain
import LedgerInterface

public struct SaveLedgerDateRangeUseCase: SaveLedgerDateRangeUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(dateRange: DateRange) {
    ledgerRepo.saveDateRange(dateRange)
  }
}
