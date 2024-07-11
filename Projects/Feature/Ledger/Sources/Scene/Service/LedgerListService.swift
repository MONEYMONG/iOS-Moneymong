import Core

import RxSwift

enum LedgerListEvent {
  case selectedDateRange(start: DateInfo, end: DateInfo)
  case createLedgerRecord
  case update
}

protocol LedgerListServiceInterface {
  var event: PublishSubject<LedgerListEvent> { get }
  func selectedDate(start: DateInfo, end: DateInfo) -> Observable<Void>
  func createLedgerRecord() -> Observable<Void>
  func updateList()
}

final class LedgerListService: LedgerListServiceInterface {
  let event = PublishSubject<LedgerListEvent>()
  
  func selectedDate(start: DateInfo, end: DateInfo) -> Observable<Void> {
    event.onNext(.selectedDateRange(start: start, end: end))
    return .empty()
  }
  
  func createLedgerRecord() -> Observable<Void> {
    event.onNext(.createLedgerRecord)
    return .empty()
  }

  func updateList() {
      event.onNext(.update)
    }
}
