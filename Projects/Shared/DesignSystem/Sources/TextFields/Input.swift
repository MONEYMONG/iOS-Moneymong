import UIKit

import PinLayout
import FlexLayout

public class Input: UIView {

  public enum State {
    case active
    case unActive
    case error

    var color: UIColor {
      switch self {
      case .active: return Colors.Blue._4
      case .unActive: return Colors.Gray._5
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
    return label
  }()

  public let textField: UITextField = {
    let textField = UITextField()
    textField.font = Fonts.body._3
    textField.selectedTextRange = nil
    textField.attributedPlaceholder = NSAttributedString(
      string: "Placeholder Text",
      attributes: [NSAttributedString.Key.foregroundColor: Colors.Gray._4]
    )
    return textField
  }()

  private let clearButton: TouchAreaButton = {
    let button = TouchAreaButton(dx: -10, dy: 0)
    button.isHidden = true
    button.setImage(
      Images.close?.withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    button.setImage(
      Images.close?.withRenderingMode(.alwaysTemplate),
      for: .highlighted
    )
    button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    button.tintColor = Colors.Gray._4
    return button
  }()

  private let colorLineView: UIView = {
    let view = UIView()
    return view
  }()

  private let charactorLimitView: CharacterLimitView

  public init(charactorLimitCount: Int, title: String, placeholeder: String? = "") {
    self.state = .unActive
    self.charactorLimitCount = charactorLimitCount
    self.charactorLimitView = CharacterLimitView(
      state: .default(characterCount: 0),
      limitCount: charactorLimitCount
    )
    super.init(frame: .zero)
    setupView(with: title, placeholeder: placeholeder)
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

  private func setupView(with title: String, placeholeder: String?) {
    addSubview(rootContainer)
    titleLabel.text = title
    textField.placeholder = placeholeder
    textField.delegate = self
    clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
  }

  private func setupConstraints() {
    rootContainer.flex.direction(.column).height(56).define { flex in
      flex.addItem(titleLabel)
      flex.addItem().height(8)

      flex.addItem().direction(.row).define { flex in
        flex.addItem(textField).grow(1)
        flex.addItem(clearButton).width(20).height(20)
      }

      flex.addItem().height(10)
      flex.addItem(colorLineView).height(1).backgroundColor(state.color)
      flex.addItem().height(2)
      flex.addItem(charactorLimitView)
    }
  }

  private func updateState() {
    titleLabel.textColor = state == .unActive ? Colors.Gray._6 : state.color
    colorLineView.backgroundColor = state.color
    textField.tintColor = state.color
  }

  @objc private func didTapClearButton() {
    state = .active
    charactorLimitView.setState(.default(characterCount: 0))
    textField.text = nil
    clearButton.isHidden = true
  }
}

extension Input: UITextFieldDelegate {
  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let currentText = textField.text,
          let stringRange = Range(range, in: currentText) else {
      return false
    }

    let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

    clearButton.isHidden = updatedText.count == 0

    if charactorLimitCount >= updatedText.count {
      state = .active
      charactorLimitView.setState(.default(characterCount: updatedText.count))
    } else {
      state = .error
      charactorLimitView.setState(.error(
        characterCount: updatedText.count,
        errorMessage: "글자수를 초과 하였습니다."
      ))
    }
    return true
  }

  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    guard let textCount = textField.text?.count, state != .error else { return true }

    state = .active
    charactorLimitView.setState(.default(characterCount: textCount))
    return true
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    guard state != .error else { return }
    state = .unActive
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension Input {
  public func setError(message: String) {
    guard let textCount = textField.text?.count else { return }
    state = .error
    charactorLimitView.setState(.error(
      characterCount: textCount,
      errorMessage: message
    ))
  }
}
