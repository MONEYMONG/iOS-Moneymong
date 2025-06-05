import BaseDomain
import LedgerFeatureInterface

import RxSwift

final class AgencyService: AgencyServiceInterface {
  let event = PublishSubject<AgencyEvent>()
  
  func updateAgency(_ agency: Agency?) {
    event.onNext(.update(agency))
  }
}
