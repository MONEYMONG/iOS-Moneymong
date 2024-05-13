import NetworkService

import RxSwift

enum LedgerEvent {
  case updateAgency(Agency)
}

protocol LedgerGlobalServiceInterface {
  var event: PublishSubject<LedgerEvent> { get }
  func updateAgency(_ agency: Agency) -> Observable<Agency>
}

final class LedgerGlobalService: LedgerGlobalServiceInterface {
  let event = PublishSubject<LedgerEvent>()
  
  func updateAgency(_ agency: Agency) -> Observable<Agency> {
    event.onNext(.updateAgency(agency))
    return .just(agency)
  }
}
