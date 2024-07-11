import Core

import RxSwift
import RxRelay

enum LedgerDetailContentsEvent {
  case isValidChanged(Bool)
  case isLoading(Bool)
}

enum ParentEvent {
  case shouldTypeChanged(LedgerContentsView.State)
  case setLedger(LedgerDetail)
}

protocol LedgerDetailContentsServiceInterface {
  var parentViewEvent: ReplaySubject<ParentEvent> { get }
  var contentsViewEvent: PublishSubject<LedgerDetailContentsEvent> { get }

  func setLedger(_ ledger: LedgerDetail)
  func shouldTypeChanged(to: LedgerContentsView.State)
  func didValidChanged(_ value: Bool)
  func setIsLoading(_ value: Bool)
}

final class LedgerDetailContentsService: LedgerDetailContentsServiceInterface {

  let parentViewEvent = ReplaySubject<ParentEvent>.create(bufferSize: 1)
  let contentsViewEvent = PublishSubject<LedgerDetailContentsEvent>()

  func setLedger(_ ledger: LedgerDetail) {
    parentViewEvent.onNext(.setLedger(ledger))
  }

  /// ContentsView Type 변경
  func shouldTypeChanged(to: LedgerContentsView.State) {
    parentViewEvent.onNext(.shouldTypeChanged(to))
  }

  func didValidChanged(_ value: Bool) {
    contentsViewEvent.onNext(.isValidChanged(value))
  }

  func setIsLoading(_ value: Bool) {
    contentsViewEvent.onNext(.isLoading(value))
  }
}
