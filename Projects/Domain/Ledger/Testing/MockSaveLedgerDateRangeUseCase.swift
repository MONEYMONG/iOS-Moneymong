import LedgerInterface
import BaseDomain

public struct MockSaveLedgerDateRangeUseCase: SaveLedgerDateRangeUseCaseInterface {
  public init() {}
  
  public func execute(dateRange: BaseDomain.DateRange) {}
}
