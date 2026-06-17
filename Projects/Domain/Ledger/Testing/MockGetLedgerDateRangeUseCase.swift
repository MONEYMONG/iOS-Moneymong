import LedgerInterface
import BaseDomain

public struct MockGetLedgerDateRangeUseCase: GetLedgerDateRangeUseCaseInterface {
  public init() {}
  
  public func execute() -> BaseDomain.DateRange? {
    return nil
  }
}
