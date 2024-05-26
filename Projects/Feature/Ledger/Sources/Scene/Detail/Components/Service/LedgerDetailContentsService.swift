import NetworkService

import RxSwift

enum LedgerDetailContentsEvent {
  case isValueChanged(Bool, LedgerDetail)
  case isValidChanged(Bool)
  case shouldDeleteImage(LedgerDetail.ImageURL)
}

protocol LedgerDetailContentsServiceInterface {
  var event: PublishSubject<LedgerDetailContentsEvent> { get }

  func didValueChanged(isChanged: Bool, item: LedgerDetail)
  func didValidChanged(_ value: Bool)
  func didDeleteImage(_ to: LedgerDetail.ImageURL)
}

final class LedgerDetailContentsService: LedgerDetailContentsServiceInterface {
  let event = PublishSubject<LedgerDetailContentsEvent>()

  func didValueChanged(isChanged: Bool, item: LedgerDetail) {
    event.onNext(.isValueChanged(isChanged, item))
  }

  func didValidChanged(_ value: Bool) {
    event.onNext(.isValidChanged(value))
  }

  func didDeleteImage(_ to: LedgerDetail.ImageURL) {
    event.onNext(.shouldDeleteImage(to))
  }
}
