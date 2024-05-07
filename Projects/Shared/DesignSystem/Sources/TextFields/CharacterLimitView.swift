import UIKit

import PinLayout
import FlexLayout

final class CharacterLimitView: UIView {

  public enum State {
    case `default`(characterCount: Int)
    case error(characterCount: Int, errorMessage: String)

    var color: UIColor {
      switch self {
      case .`default`: return Colors.Gray._5
      case .error: return Colors.Red._3
      }
    }
  }

  private var state: State {
    didSet { updateState() }
  }

  private let errorMessageLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textColor = Colors.Red._3
    return label
  }()

  private let currentCountLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.numberOfLines = 1
    return label
  }()

  private var currentCount: Int = 0
  private let limitCount: Int

  private let rootContainer = UIView()

  init(state: State = .default(characterCount: 0), limitCount: Int) {
    self.state = state
    self.limitCount = limitCount
    currentCountLabel.isHidden = limitCount == 0
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
    updateState()
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

  private func setupUI() {
    addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .height(16)
      .define { flex in
        flex.addItem(errorMessageLabel)
        flex.addItem().grow(1)
        flex.addItem(currentCountLabel)
      }
  }

  private func updateState() {
    switch state {
    case .default(let characterCount):
      currentCountLabel.text = String(format: "%d/%d", characterCount, limitCount)
      currentCountLabel.textColor = state.color
      errorMessageLabel.flex.display(.none)
    case .error(let characterCount, let message):
      currentCountLabel.text = String(format: "%d/%d", characterCount, limitCount)
      currentCountLabel.textColor = state.color
      errorMessageLabel.flex.display(.flex)
      errorMessageLabel.setTextWithLineHeight(text: message, lineHeight: 16)
    }
    currentCountLabel.flex.markDirty()
    errorMessageLabel.flex.markDirty()
    rootContainer.flex.layout()
    setNeedsLayout()
  }
}

extension CharacterLimitView {
  public func setState(_ state: State) {
    self.state = state
  }
}
