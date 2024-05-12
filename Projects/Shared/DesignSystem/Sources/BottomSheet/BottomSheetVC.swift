import UIKit

import PinLayout
import FlexLayout

open class BottomSheetVC: UIViewController {
  private let rootContainer = UIView()
  private let spaceView = UIView()
  private let sheetView = UIView()
  public let contentView = UIView()

  private lazy var panGesture: UIPanGestureRecognizer = {
    let g = UIPanGestureRecognizer(target: self, action: #selector(gestureAction))
    g.delaysTouchesBegan = false
    g.delaysTouchesEnded = false
    return g
  }()
  
  private var spaceViewHeight: CGFloat = 0
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    setupUI()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
    contentView.pin.all()
    contentView.flex.layout()
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    show()
    spaceViewHeight = spaceView.frame.height
  }
  
  open func setupUI() {
    view.backgroundColor = .clear
    sheetView.addGestureRecognizer(panGesture)
  }
  
  open func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.define { flex in
      flex.addItem(spaceView).height(UIScreen.main.bounds.height)
      flex.addItem(sheetView).backgroundColor(.white).cornerRadius(20)
    }
    sheetView.addSubview(contentView)
  }
  
  @objc
  private func gestureAction(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: view)
    let velocity = recognizer.velocity(in: view)
    view.setNeedsLayout()
    switch recognizer.state {
    case .changed:
      let h = spaceViewHeight + translation.y
      spaceView.flex.height(h).grow(1).markDirty()
      view.layoutIfNeeded()
    case .ended:
      if spaceView.frame.height > UIScreen.main.bounds.height * 0.7 ||
          velocity.y > 500 {
        dismiss()
      } else {
        show()
      }
    default:
      break
    }
  }
  
  public func show() {
    view.setNeedsLayout()
    spaceView.flex.height(nil).grow(1).markDirty()
    UIView.animate(withDuration: 0.2) {
      self.view.backgroundColor = Colors.Gray._10.withAlphaComponent(0.7)
      self.view.layoutIfNeeded()
    }
  }
  
  public func dismiss() {
    view.setNeedsLayout()
    spaceView.flex.height(UIScreen.main.bounds.height).grow(1).markDirty()
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    } completion: { _ in
      self.dismiss(animated: true)
    }
  }
}
