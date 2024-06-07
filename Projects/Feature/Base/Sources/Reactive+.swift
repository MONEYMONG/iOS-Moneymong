import UIKit

import DesignSystem

import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
  var isLoading: Binder<Bool> {
    let loadingIndicator = MMLodingIndicatorVC()
    return Binder(base) { target, value in
      target.view.isUserInteractionEnabled = !value
      target.navigationController?.navigationBar.isUserInteractionEnabled = !value
      if value {
        target.addChild(loadingIndicator)
        loadingIndicator.view.frame = target.view.frame
        target.view.addSubview(loadingIndicator.view)
        loadingIndicator.didMove(toParent: target)
      } else {
        loadingIndicator.willMove(toParent: nil)
        loadingIndicator.removeFromParent()
        loadingIndicator.view.removeFromSuperview()
      }
    }
  }
}

public extension Reactive where Base: UIView {
  var tapGesture: ControlEvent<Base> {
    let tapGesture = UITapGestureRecognizer()
    base.addGestureRecognizer(tapGesture)
    let event = tapGesture.rx.event
      .withUnretained(base)
      .flatMap { (base, _) in
        Observable.just(base)
      }
    return ControlEvent(events: event)
  }

  var swipeLeftGesture: ControlEvent<Base> {
    let swiftGesture = UISwipeGestureRecognizer()
    swiftGesture.direction = .left
    base.addGestureRecognizer(swiftGesture)
    let event = swiftGesture.rx.event
      .withUnretained(base)
      .flatMap { (base, _) in
        Observable.just(base)
      }
    return ControlEvent(events: event)
  }
}
