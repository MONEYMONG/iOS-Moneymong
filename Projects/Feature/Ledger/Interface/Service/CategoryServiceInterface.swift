import BaseDomain

import RxSwift

public enum CategoryEvent {
  case update([MMCategory])
}

public protocol CategoryServiceInterface {
  var event: PublishSubject<CategoryEvent> { get }
}
