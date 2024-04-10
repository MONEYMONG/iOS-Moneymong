import DesignSystem
import UIKit

final class ColorLineCharacterLimitView: UIView {

  public enum State {
    case active(Int)
    case unActive
    case error(String)

    var lineColor: UIColor {
      switch self {
      case .active: return Colors.Blue._4
      case .unActive: return Colors.Gray._5
      case .error: return Colors.Red._3
      }
    }

    var labelColor: UIColor {
      switch self {
      case .active: return Colors.Gray._5
      case .unActive: return Colors.Gray._5
      case .error: return Colors.Red._3
      }
    }
  }

  private var state: State {
    didSet { updateState() }
  }

  private let colorLineView: UIView = {
    let view = UIView()
    return view
  }()

  private let errorMessageLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textColor = .red
    return label
  }()

  private let currentCountLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    return label
  }()

  private var currentCount: Int = 0
  private let limitCount: Int

  private let rootContainer = UIView()

  init(state: State = .unActive, limitCount: Int) {
    self.state = state
    self.limitCount = limitCount
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
    updateState()
  }

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
    currentCountLabel.text = String(format: "%d/%d", currentCount, limitCount)
  }

  private func setupConstraints() {
    rootContainer.flex.direction(.column).height(20).define { flex in

      flex.direction(.row).define { flex in
        flex.addItem(colorLineView).height(2)
      }

      flex.addItem().height(2)

      flex.direction(.row).define { flex in
        flex.addItem(errorMessageLabel)
        flex.addItem().grow(1)
        flex.addItem(currentCountLabel)
      }
    }
  }

  private func updateState() {
    colorLineView.backgroundColor = state.lineColor

    switch state {
    case .active(let charactorCount):
      currentCountLabel.textColor = state.labelColor
      errorMessageLabel.flex.display(.none)
      currentCount = charactorCount
    case .unActive:
      currentCountLabel.textColor = state.labelColor
      errorMessageLabel.flex.display(.none)
    case .error(let message):
      currentCountLabel.textColor = state.labelColor
      errorMessageLabel.flex.display(.flex)
      errorMessageLabel.text = message
    }

    rootContainer.flex.layout()
  }
}

extension ColorLineCharacterLimitView {
  public func setState(_ state: State) {
    self.state = state
  }
}
