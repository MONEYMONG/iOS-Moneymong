import UIKit

import Utility
import DesignSystem

import PinLayout
import FlexLayout

final class DefaultSectionHeader: UICollectionReusableView, ReusableView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    v.font = Fonts.body._2
    return v
  }()

  private let rootContainer = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex.define { flex in
      flex.addItem(titleLabel).marginLeft(16)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  func configure(title: String) -> Self {
    titleLabel.setTextWithLineHeight(text: title, lineHeight: 18)
    titleLabel.flex.markDirty()
    setNeedsLayout()
    return self
  }
}
