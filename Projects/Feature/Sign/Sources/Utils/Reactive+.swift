import UIKit

import RxSwift

import DesignSystem

extension Reactive where Base: UIViewController {
  func isLoading() -> Binder<Bool> {
    let loadingIndicator = MMLodingIndicatorVC()
    return Binder(base) { target, value in
      target.view.isUserInteractionEnabled = !value
      target.navigationController?.navigationBar.isUserInteractionEnabled = !value
      if value == true {
        loadingIndicator.view.frame = target.view.frame
        target.view.addSubview(loadingIndicator.view)
      } else {
        loadingIndicator.removeFromParent()
        loadingIndicator.view.removeFromSuperview()
      }
    }
  }
}
