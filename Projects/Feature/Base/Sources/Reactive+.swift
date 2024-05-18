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
        loadingIndicator.view.frame = target.view.frame
        target.view.addSubview(loadingIndicator.view)
      } else {
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
}