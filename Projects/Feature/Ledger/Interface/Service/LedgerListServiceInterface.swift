import BaseDomain

import RxSwift

public enum LedgerListEvent {
  case selectedDateRange(start: DateInfo, end: DateInfo)
  case createLedgerRecord
  case update
}

public protocol LedgerListServiceInterface {
  var event: PublishSubject<LedgerListEvent> { get }
  func selectedDate(start: DateInfo, end: DateInfo) -> Observable<Void>
  func createLedgerRecord() -> Observable<Void>
  func updateList()
}

