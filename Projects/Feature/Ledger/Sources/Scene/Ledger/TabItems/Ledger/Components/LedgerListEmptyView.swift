import UIKit

import DesignSystem

import FlexLayout
import PinLayout

final class LedgerListEmptyView: UIView {
  private let rootContainer = UIView()
  
  private let label: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._7
    v.font = Fonts.body._3
    v.text = "장부 기록이 없어요"
    return v
  }()
  
  init() {
    super.init(frame: .zero)
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
 
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
      flex.addItem(UIImageView(image: Images.mongLedgerEmpty))
      flex.addItem(label).alignSelf(.center)
    }
  }
}

