import NetworkService

import RxSwift

// Agency 관련 전역 이벤트들이 필요할 경우 추가
enum AgencyEvent {
  case update(Agency)
}

protocol AgencyServiceInterface {
  var event: PublishSubject<AgencyEvent> { get }
  func updateAgency(_ agency: Agency) -> Observable<Agency>
}

final class AgencyService: AgencyServiceInterface {
  let event = PublishSubject<AgencyEvent>()
  
  func updateAgency(_ agency: Agency) -> Observable<Agency> {
    event.onNext(.update(agency))
    return .just(agency)
  }
}
