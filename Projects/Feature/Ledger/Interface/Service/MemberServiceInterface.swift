import RxSwift

// Member 관련 전역 이벤트들이 필요한 경우 추가
public enum MemberEvent {
  case updateRole
  case kickOff(memberID: Int)
}

public protocol MemberServiceInterface {
  var event: PublishSubject<MemberEvent> { get }
  func update() -> Observable<Void>
  func kickOff(_ memberID: Int) -> Observable<Int>
}

