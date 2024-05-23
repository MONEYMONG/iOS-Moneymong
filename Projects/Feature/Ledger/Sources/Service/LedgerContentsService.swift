import NetworkService

import RxSwift

enum LedgerContentsEvent {
  case isValueChanged(Bool)
  case isValidChanged(Bool)
}

protocol LedgerContentsServiceInterface {
  var event: PublishSubject<LedgerContentsEvent> { get }

  func didValueChanged(_ value: Bool)
  func didValidChanged(_ value: Bool)
}

final class LedgerContentsService: LedgerContentsServiceInterface {
  let event = PublishSubject<LedgerContentsEvent>()

  func didValueChanged(_ value: Bool) {
    print("값변경")
    event.onNext(.isValueChanged(value))
  }

  func didValidChanged(_ value: Bool) {
    event.onNext(.isValidChanged(value))
  }
}
