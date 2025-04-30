import UIKit

import DesignSystem

import FlexLayout
import PinLayout

final class LedgerListEmptyView: UIView {
  private let rootContainer = UIView()
  
  private let contentLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._5
    v.numberOfLines = 2
    v.textAlignment = .center
    v.font = Fonts.body._3
    return v
  }()
  
  private let iconImageView = UIImageView(image: Images.ledgerEmpty)
  
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
      flex.addItem(iconImageView).marginBottom(4)
      flex.addItem(contentLabel)
    }
  }
  
  func configure(_ index: Int) {
    switch index {
    case 0:
      iconImageView.image = Images.ledgerEmpty
      contentLabel.text = "장부 내역을 기록하세요"
    case 1:
      iconImageView.image = Images.expensesEmpty
      contentLabel.text = "지출 기록이 없어요"
    case 2:
      iconImageView.image = Images.importEmpty
      contentLabel.text = "수입 기록이 없어요"
    default: break
    }
    
    iconImageView.flex.markDirty()
    contentLabel.flex.markDirty()
    setNeedsLayout()
  }
}

