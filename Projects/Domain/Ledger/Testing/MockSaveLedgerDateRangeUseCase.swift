import LedgerInterface
import BaseDomain

public struct MockSaveLedgerDateRangeUseCase: SaveLedgerDateRangeUseCaseInterface {
  public init() {}
  
  public func excute(dateRange: BaseDomain.DateRange) {}
}
