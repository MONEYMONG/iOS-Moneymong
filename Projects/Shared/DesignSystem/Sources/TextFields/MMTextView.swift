import UIKit

import PinLayout
import FlexLayout

public class MMTextView: UIView {

  public enum State {
    case active
    case unActive
    case error

    var color: UIColor {
      switch self {
      case .active: return Colors.Blue._4
      case .unActive: return Colors.Gray._6
      case .error: return Colors.Red._3
      }
    }
  }

  private var state: State {
    didSet { updateState() }
  }

  private let charactorLimitCount: Int

  private let rootContainer = UIView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._2
    return label
  }()

  private(set) var textView: UITextView = {
    let textView = UITextView()
    textView.font = Fonts.body._3
    textView.selectedTextRange = nil
    textView.isScrollEnabled = false
    textView.setContentHuggingPriority(.defaultLow, for: .vertical)
    textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    return textView
  }()

  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._3
    label.textColor = Colors.Gray._4
    label.isHidden = false
    return label
  }()

  private let colorLineView: UIView = {
    let view = UIView()
    return view
  }()

  private let charactorLimitView: CharacterLimitView

  public init(charactorLimitCount: Int = 0, title: String, placeholeder: String? = "") {
    self.state = .unActive
    self.charactorLimitCount = charactorLimitCount
    self.charactorLimitView = CharacterLimitView(
      state: .default(characterCount: 0),
      limitCount: charactorLimitCount
    )
    self.charactorLimitView.isHidden = charactorLimitCount == 0
    super.init(frame: .zero)
    setupView(with: title, placeholeder: placeholeder)
    setupConstraints()
    updateState()
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

  private func setupView(with title: String, placeholeder: String?) {
    addSubview(rootContainer)
    titleLabel.text = title
    placeholderLabel.text = placeholeder
    textView.delegate = self
  }

  private func setupConstraints() {
    rootContainer.flex.direction(.column).height(.infinity).grow(1).define { flex in
      flex.addItem(titleLabel)

      flex.addItem().direction(.row).define { flex in
        flex.addItem(textView).minHeight(150).grow(1)
        flex.addItem(placeholderLabel).position(.absolute).top(8).left(3)
      }

      flex.addItem().height(10)
      flex.addItem(colorLineView).height(1).backgroundColor(state.color)
      flex.addItem().height(2)
      flex.addItem(charactorLimitView).grow(0)
    }
  }

  private func updateState() {
    titleLabel.textColor = state.color
    colorLineView.backgroundColor = state == .unActive ? Colors.Gray._2 : state.color
    textView.tintColor = state.color
    placeholderLabel.isHidden = textView.text.count != 0
  }

  @objc private func didTapClearButton() {
    state = .active
    charactorLimitView.setState(.default(characterCount: 0))
    textView.text = nil
  }
}

extension MMTextView: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    if charactorLimitCount >= textView.text.count {
      state = .active
      charactorLimitView.setState(.default(characterCount: textView.text.count))
    } else if charactorLimitCount != 0 {
      state = .error
      charactorLimitView.setState(.error(
        characterCount: textView.text.count,
        errorMessage: "글자수를 초과 하였습니다"
      ))
    }

    textView.flex.markDirty()
    textView.flex.layout()
    textView.setNeedsLayout()
    rootContainer.flex.markDirty()
    rootContainer.flex.layout()
    rootContainer.setNeedsLayout()
  }

  public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    guard state != .error else { return true }

    state = .active
    charactorLimitView.setState(.default(characterCount: textView.text.count))
    return true
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    guard state != .error else { return }
    state = .unActive
  }
}

extension MMTextView {
  public func setError(message: String) {
    state = .error
    charactorLimitView.setState(.error(
      characterCount: textView.text.count,
      errorMessage: message
    ))
  }
}
