import UIKit

import BaseFeature
import ReactorKit
import PinLayout
import FlexLayout
import DesignSystem

public final class LedgerVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: Coordinator?
  private let childVC: [UIViewController]
  
  private lazy var lineTab = LineTabViewController(childVC)
  
  init(_ childVC: [UIViewController]) {
    self.childVC = childVC
    super.init()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.safeAreaInsets)
  }
  
  public override func setupUI() {
    super.setupUI()
  }
  
  public override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .define { flex in
        flex.addItem(lineTab.view)
      }
  }
  
  public func bind(reactor: LedgerReactor) {
    
  }
}
