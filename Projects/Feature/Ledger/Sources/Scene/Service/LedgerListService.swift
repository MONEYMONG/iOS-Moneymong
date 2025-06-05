import BaseDomain
import LedgerFeatureInterface

import RxSwift

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
