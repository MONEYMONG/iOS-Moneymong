import BaseDomain

public protocol GetLedgerDateRangeUseCaseInterface {
  func execute() -> DateRange?
}
