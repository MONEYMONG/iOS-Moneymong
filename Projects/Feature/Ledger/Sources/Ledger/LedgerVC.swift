import UIKit

import BaseFeature
import ReactorKit
import PinLayout
import FlexLayout
import DesignSystem

public final class LedgerVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?
  
  private let lineTab: LineTabViewController!
  
  init(_ childVC: [UIViewController]) {
    self.lineTab = LineTabViewController(childVC)
    super.init()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
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
