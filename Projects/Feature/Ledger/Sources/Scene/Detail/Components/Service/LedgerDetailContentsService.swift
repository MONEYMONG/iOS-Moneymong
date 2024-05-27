import NetworkService

import RxSwift

enum LedgerDetailContentsEvent {
  case isValidChanged(Bool)
}

enum ParentEvent {
  case shouldTypeChanged(LedgerContentsView.State)
  case shouldLedgerInfoUpdate(Void)
}

protocol LedgerDetailContentsServiceInterface {
  var contentsViewEvent: PublishSubject<LedgerDetailContentsEvent> { get }
  var parentViewEvent: PublishSubject<ParentEvent> { get }

  func didValidChanged(_ value: Bool)

  func shouldTypeChanged(to: LedgerContentsView.State)
}

final class LedgerDetailContentsService: LedgerDetailContentsServiceInterface {
  let contentsViewEvent = PublishSubject<LedgerDetailContentsEvent>()
  let parentViewEvent = PublishSubject<ParentEvent>()

  func didValidChanged(_ value: Bool) {
    contentsViewEvent.onNext(.isValidChanged(value))
  }

  /// ContentsView Type 변경
  func shouldTypeChanged(to: LedgerContentsView.State) {
    parentViewEvent.onNext(.shouldTypeChanged(to))
  }

  func shouldLedgerInfoUpdate() {
    parentViewEvent.onNext(.shouldLedgerInfoUpdate(()))
  }
}
