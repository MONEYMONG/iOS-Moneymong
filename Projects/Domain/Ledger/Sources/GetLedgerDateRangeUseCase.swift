import Foundation

import BaseDomain
import LedgerInterface

public struct GetLedgerDateRangeUseCase: GetLedgerDateRangeUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute() -> DateRange? {
    ledgerRepo.fetchDateRange()
  }
}
