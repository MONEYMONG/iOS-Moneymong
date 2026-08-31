import UIKit

import DesignSystem

import PinLayout
import FlexLayout

final class InvitationLinkButton: UIButton {
  private let rootContainer = UIView()

  private let badgeView: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Black._1.withAlphaComponent(0.2)
    v.layer.cornerRadius = 4
    return v
  }()

  private let badgeLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.caption
    v.textColor = Colors.White._1
    v.text = "이걸로 초대해보세요"
    return v
  }()

  private let buttonTitleLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.textColor = Colors.White._1
    v.text = "친구 초대하기"
    return v
  }()

  override var isHighlighted: Bool {
    didSet { alpha = isHighlighted ? 0.7 : 1 }
  }

  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    backgroundColor = Colors.Blue._4
    clipsToBounds = true
  }

  private func setupConstraints() {
    rootContainer.isUserInteractionEnabled = false
    addSubview(rootContainer)

    rootContainer.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .paddingVertical(14)
      .define { flex in
        flex.addItem(badgeView).marginRight(8).define { flex in
          flex.addItem(badgeLabel).marginHorizontal(8).marginVertical(4)
        }
        flex.addItem(buttonTitleLabel)
      }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    rootContainer.pin.all()
    rootContainer.flex.layout()

    layer.cornerRadius = 10
  }
}
