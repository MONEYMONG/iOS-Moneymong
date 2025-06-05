import BaseDomain

import RxSwift

// Agency 관련 전역 이벤트들이 필요할 경우 추가
public enum AgencyEvent {
  case update(Agency?)
}

public protocol AgencyServiceInterface {
  var event: PublishSubject<AgencyEvent> { get }
  func updateAgency(_ agency: Agency?)
}

