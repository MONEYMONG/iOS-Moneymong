import UIKit

import RxSwift

extension Reactive where Base: UIViewController {
  func isLoading() -> Binder<Bool> {
    let loadingIndicator = LoadingIndicatorViewController()
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
