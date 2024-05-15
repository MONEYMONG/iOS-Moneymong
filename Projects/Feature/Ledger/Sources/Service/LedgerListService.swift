import NetworkService

import RxSwift

enum LedgerListEvent {
  case selectedDateRange(start: DateInfo, end: DateInfo)
  case createLedgerRecord
}

protocol LedgerListServiceInterface {
  var event: PublishSubject<LedgerListEvent> { get }
  func selectedDate(start: DateInfo, end: DateInfo)
  func createLedgerRecord() -> Observable<Void>
}

final class LedgerListService: LedgerListServiceInterface {
  let event = PublishSubject<LedgerListEvent>()
  
  func selectedDate(start: DateInfo, end: DateInfo) {
    event.onNext(.selectedDateRange(start: start, end: end))
  
  func createLedgerRecord() -> Observable<Void> {
    event.onNext(.createLedgerRecord)
    return .empty()
  }
}


