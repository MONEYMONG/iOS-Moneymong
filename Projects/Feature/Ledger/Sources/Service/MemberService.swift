import NetworkService

import RxSwift

// Member 관련 전역 이벤트들이 필요한 경우 추가
enum MemberEvent {
  case update
}

protocol MemberServiceInterface {
  var event: PublishSubject<MemberEvent> { get }
  func update() -> Observable<Void>
}

final class MemberService: MemberServiceInterface {
  let event = PublishSubject<MemberEvent>()
  
  func update() -> Observable<Void> {
    event.onNext(.update)
    return .empty()
  }
}

