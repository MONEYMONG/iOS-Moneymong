import UIKit
import RxSwift
import RxCocoa
import PinLayout
import FlexLayout

/// BaseView
open class BaseV: UIView {
  public let rootContainer = UIView()

  public init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  open func setupUI() {
    backgroundColor = .white
  }

  open func setupConstraints() {
    addSubview(rootContainer)
  }
}
