import LedgerFeatureInterface

import RxSwift

final class MemberService: MemberServiceInterface {
  let event = PublishSubject<MemberEvent>()
  
  func update() -> Observable<Void> {
    event.onNext(.updateRole)
    return .empty()
  }
  
  func kickOff(_ memberID: Int) -> Observable<Int> {
    event.onNext(.kickOff(memberID: memberID))
    return .empty()
  }
}

