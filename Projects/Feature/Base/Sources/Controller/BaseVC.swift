import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

/// BaseViewController
open class BaseVC: UIViewController {
  public let rootContainer = UIView()
  
  public init() {
      super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }

  open func setupUI() {
    view.backgroundColor = .white
  }
  
  open func setupConstraints() {
    view.addSubview(rootContainer)
  }
}
