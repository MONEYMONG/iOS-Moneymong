import UIKit

import RxSwift
import RxCocoa

/// RxViewController
public extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewWillAppear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewDidAppear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewWillDisappear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewDidDisappear: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewWillLayoutSubviews: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
    return ControlEvent(events: source)
  }
  
  var viewDidLayoutSubviews: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
    return ControlEvent(events: source)
  }
}
