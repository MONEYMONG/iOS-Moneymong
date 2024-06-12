import UIKit

import DesignSystem

import FlexLayout
import PinLayout

final class LedgerListEmptyView: UIView {
  private let rootContainer = UIView()
  
  private let contentLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._7
    v.numberOfLines = 2
    v.textAlignment = .center
    return v
  }()
  
  private let iconImageView = UIImageView(image: Images.mongLedgerEmpty)
  
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
      flex.addItem(iconImageView)
      flex.addItem(contentLabel)
    }
  }
  
  func configure(_ index: Int) {
    switch index {
    case 0:
      iconImageView.image = Images.scanPhone
      contentLabel.font = Fonts.body._3
      contentLabel.setTextWithLineHeight(text: "카메라로 영수증을 스캔해서\n  손쉽게 장부를 기록하세요", lineHeight: 24)
    case 1:
      iconImageView.image = Images.mongLedgerEmpty
      contentLabel.font = Fonts.body._3
      contentLabel.setTextWithLineHeight(text: "지출 기록이 없어요", lineHeight: 20)
    case 2:
      iconImageView.image = Images.mongLedgerEmpty
      contentLabel.font = Fonts.body._3
      contentLabel.setTextWithLineHeight(text: "수입 기록이 없어요", lineHeight: 20)
    default: break
    }
    
    iconImageView.flex.markDirty()
    contentLabel.flex.markDirty()
    setNeedsLayout()
  }
}

