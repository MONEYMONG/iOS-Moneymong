import UIKit

import DesignSystem

final class Bubble: UIView {
  private let rootContainer = UIView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.setTextWithLineHeight(text: "", lineHeight: 20)
    label.font = Fonts.body._3
    label.textColor = Colors.Blue._4
    return label
  }()

  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  private func setupUI() {
    addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex
      .alignItems(.center)
      .height(49)
      .define { flex in

      flex.addItem()
        .height(40)
        .cornerRadius(8)
        .backgroundColor(Colors.White._1)
        .alignItems(.center)
        .justifyContent(.center)
        .paddingHorizontal(14)
        .define { flex in
          flex.addItem(titleLabel)
        }

        flex.addItem(Triangle())
          .marginTop(-1)
          .width(12)
          .height(10)
    }
  }
}

extension Bubble {
  func setTitle(to text: String) {
    titleLabel.text = text
  }
}
