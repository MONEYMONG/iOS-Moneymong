import LedgerInterface
import BaseDomain

public struct MockGetLedgerDateRangeUseCase: GetLedgerDateRangeUseCaseInterface {
  public init() {}
  
  public func excute() -> BaseDomain.DateRange? {
    return nil
  }
}
