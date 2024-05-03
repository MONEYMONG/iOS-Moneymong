import UIKit

import FlexLayout
import PinLayout

public class ToolTip: UIView {
  public enum `Type` {
    case top
    case bottom
  }

  private let titleLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  private let type: `Type`

  public let tip: Tip

  private let contentsView = UIView()

  private let rootContainer = UIView()

  public init(type: `Type` = .bottom) {
    self.type = type
    self.tip = Tip(type: type)
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

    rootContainer.pin.center()
    rootContainer.flex.layout(mode: .adjustWidth)
  }

  private func setupUI() {
    addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex.height(50).define { flex in

      if type == .top {
        flex.addItem(tip)
          .width(12)
          .height(10)
          .position(.absolute)
          .alignSelf(.center)
          .top(0)
      }

      flex.addItem(contentsView)
        .padding(10, 14)
        .alignItems(.center)
        .justifyContent(.center)
        .marginTop(type == .top ? 10 : 0)
        .define { flex in
          flex.addItem(titleLabel)
        }

      if type == .bottom {
        flex.addItem(tip)
          .width(12)
          .height(10)
          .position(.absolute)
          .alignSelf(.center)
          .bottom(0)
      }
    }
  }
}

public extension ToolTip {

  // ToolTip 높이가 동적 계산이 불가하여 lineHeight = 20 고정
  func setTitle(with title: String) {
    titleLabel.setTextWithLineHeight(text: title, lineHeight: 20)
    titleLabel.flex.markDirty()
    setNeedsLayout()
  }

  func setTitleColor(with color: UIColor) {
    titleLabel.textColor = color
  }

  func setFonts(with font: UIFont) {
    titleLabel.font = font
  }

  func setBackgroundColor(with color: UIColor) {
    contentsView.flex.backgroundColor(color)
    tip.setColor(with: color)
  }

  func setCorneradius(_ to: CGFloat) {
    contentsView.flex.cornerRadius(to).markDirty()
    setNeedsLayout()
  }

  func setTipPadding(left to: CGFloat) {
    tip.flex.left(to).markDirty()
    setNeedsLayout()
  }

  func setTipPadding(right to: CGFloat) {
    tip.flex.right(to).markDirty()
    setNeedsLayout()
  }
}
