import NetworkService

import RxSwift

enum LedgerListEvent {
  case selectedDateRange(start: DateInfo, end: DateInfo)
}

protocol LedgerListServiceInterface {
  var event: PublishSubject<LedgerListEvent> { get }
  func selectedDate(start: DateInfo, end: DateInfo)
}

final class LedgerListService: LedgerListServiceInterface {
  let event = PublishSubject<LedgerListEvent>()
  
  func selectedDate(start: DateInfo, end: DateInfo) {
    event.onNext(.selectedDateRange(start: start, end: end))
  }
}


