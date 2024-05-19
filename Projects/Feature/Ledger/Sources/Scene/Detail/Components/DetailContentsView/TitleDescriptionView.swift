import UIKit

import DesignSystem

final class TitleDescriptionView: UIView {
  private let rootContainer = UIView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._2
    label.textColor = Colors.Gray._6
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._3
    label.textColor = Colors.Gray._10
    return label
  }()

  init() {
    super.init(frame: .zero)
    setConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  func setConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.define { flex in
      flex.addItem(titleLabel)
      flex.addItem().height(8)
      flex.addItem(descriptionLabel)
    }
  }

  func configure(title: String, description: String) {
    titleLabel.setTextWithLineHeight(text: title, lineHeight: 18)
    descriptionLabel.setTextWithLineHeight(text: description, lineHeight: 20)

    titleLabel.flex.markDirty()
    descriptionLabel.flex.markDirty()
    rootContainer.setNeedsLayout()
  }
}
