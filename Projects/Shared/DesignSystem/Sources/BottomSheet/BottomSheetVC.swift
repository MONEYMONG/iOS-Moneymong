import UIKit

import PinLayout
import FlexLayout

/// BottomSheet 컴포넌트 객체
///
/// 위 타입을 상속하여 사용하세요.
/// BottomSheetVC를 present시 
/// modalPresentationStyle을 .overFullScreen로 설정 후
/// animated를 false로 설정해서 사용합니다.
open class BottomSheetVC: UIViewController {
  private let rootContainer = UIView()
  private let dimView = UIView()
  private let sheetView = UIView()
  public let contentView = UIView()

  private lazy var panGesture: UIPanGestureRecognizer = {
    let g = UIPanGestureRecognizer(target: self, action: #selector(panAction))
    g.delaysTouchesBegan = false
    g.delaysTouchesEnded = false
    return g
  }()
  
  private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
  
  private var dimViewHeight: CGFloat = 0
  
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
    dimViewHeight = dimView.frame.height
  }
  
  open func setupUI() {
    view.backgroundColor = .clear
    sheetView.addGestureRecognizer(panGesture)
    dimView.addGestureRecognizer(tapGesture)
  }
  
  open func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.define { flex in
      flex.addItem(dimView).height(UIScreen.main.bounds.height)
      flex.addItem(sheetView).backgroundColor(.white).cornerRadius(20)
    }
    sheetView.addSubview(contentView)
  }
  
  @objc
  private func panAction(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: view)
    let velocity = recognizer.velocity(in: view)
    view.setNeedsLayout()
    switch recognizer.state {
    case .changed:
      let h = dimViewHeight + translation.y
      dimView.flex.height(h).grow(1).markDirty()
      view.layoutIfNeeded()
    case .ended:
      if dimView.frame.height > UIScreen.main.bounds.height - (sheetView.frame.height * 0.5) ||
          velocity.y > 500 {
        dismiss()
      } else {
        show()
      }
    default:
      break
    }
  }
  
  @objc
  private func tapAction() {
    dismiss()
  }
  
  private func show() {
    view.setNeedsLayout()
    dimView.flex.height(nil).grow(1).markDirty()
    UIView.animate(withDuration: 0.2) {
      self.view.backgroundColor = Colors.Gray._10.withAlphaComponent(0.7)
      self.view.layoutIfNeeded()
    }
  }
  
  public func dismiss(completion: (() -> Void)? = nil) {
    view.setNeedsLayout()
    dimView.flex.height(UIScreen.main.bounds.height).grow(1).markDirty()
    UIView.animate(withDuration: 0.2) {
      self.view.backgroundColor = Colors.Gray._10.withAlphaComponent(0.0)
      self.view.layoutIfNeeded()
    } completion: { _ in
      
      self.dismiss(animated: false) {
        completion?()
      }
    }
  }
  
  /// Sheet 내부 UI를 수정할 때 사용
  ///
  /// 클로저 내부에 UI 수정에 필요한 코드를 작성하세요.
  public func update(c: () -> Void) {
    view.setNeedsLayout()
    c()
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    } completion: { _ in
      self.dimViewHeight = self.dimView.frame.height
    }
  }
}
