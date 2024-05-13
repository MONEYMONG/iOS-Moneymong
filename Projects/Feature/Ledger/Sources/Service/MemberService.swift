import NetworkService

import RxSwift

// Member 관련 전역 이벤트들이 필요한 경우 추가
enum MemberEvent {
  case updateRole
  case kickOff(memberID: Int)
}

protocol MemberServiceInterface {
  var event: PublishSubject<MemberEvent> { get }
  func update() -> Observable<Void>
  func kickOff(_ memberID: Int) -> Observable<Int>
}

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

