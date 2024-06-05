import UIKit

import Utility
import DesignSystem
import NetworkService

import FlexLayout
import PinLayout

final class DateCell: UICollectionViewCell, ReusableView {
  private let dateLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.heading._2
    v.textColor = Colors.Gray._300
    return v
  }()

  private let rootContainer = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)

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

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(dateLabel)
    }.justifyContent(.center).alignItems(.center)
  }

  func configure(date: String) -> Self {
    dateLabel.text = date
    dateLabel.flex.markDirty()
    return self
  }
  
  func setTitleColor(_ color: UIColor) {
    dateLabel.textColor = color
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    dateLabel.textColor = Colors.Gray._300
  }
}
