import UIKit

import DesignSystem
import Utility

import FlexLayout
import PinLayout

final class DescriptionCell: UICollectionViewCell, ReusableView {
  private let rootContainer = UIView()

  private let descriptionLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._10
    return v
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  private func setupView() {
    contentView.addSubview(rootContainer)
  }

  private func setupConstraints() {
    contentView.addSubview(rootContainer)

    rootContainer.flex
      .define { flex in
        flex.addItem(descriptionLabel)
      }
  }

  func configure(with description: String) -> Self {
    descriptionLabel.setTextWithLineHeight(text: description, lineHeight: 20)
    descriptionLabel.flex.markDirty()
    setNeedsLayout()
    return self
  }
}
