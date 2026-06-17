import BaseDomain

public protocol SaveLedgerDateRangeUseCaseInterface {
  func execute(dateRange: DateRange)
}
