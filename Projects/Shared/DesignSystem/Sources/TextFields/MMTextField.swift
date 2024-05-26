import UIKit

import PinLayout
import FlexLayout

public class MMTextField: UIView {

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

  private let asteriskLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._2
    label.textColor = Colors.Red._3
    label.text = "*"
    return label
  }()

  public let textField: UITextField = {
    let textField = UITextField()
    textField.font = Fonts.body._3
    textField.textColor = Colors.Gray._8
    textField.selectedTextRange = nil
    textField.attributedPlaceholder = NSAttributedString(
      string: "Placeholder Text",
      attributes: [NSAttributedString.Key.foregroundColor: Colors.Gray._4]
    )
    return textField
  }()

  public let clearButton: TouchAreaButton = {
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

  private let colorLineView = UIView()

  private let charactorLimitView: CharacterLimitView

  public init(charactorLimitCount: Int = 0, title: String = "") {
    self.state = .unActive
    self.charactorLimitCount = charactorLimitCount
    self.charactorLimitView = CharacterLimitView(
      state: .default(characterCount: 0),
      limitCount: charactorLimitCount
    )
    super.init(frame: .zero)
    setupView(with: title)
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

  private func setupView(with title: String) {
    addSubview(rootContainer)
    titleLabel.text = title
    textField.delegate = self
    clearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
  }

  private func setupConstraints() {
    rootContainer.flex.direction(.column).define { flex in

        flex.addItem().direction(.row).define { flex in
          flex.addItem(titleLabel)
          flex.addItem().width(2)
          flex.addItem(asteriskLabel)
        }
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
    titleLabel.textColor = state.color
    colorLineView.backgroundColor = state == .unActive ? Colors.Gray._2 : state.color
    textField.tintColor = state.color
  }

  @objc private func didTapClearButton() {
    state = .active
    charactorLimitView.setState(.default(characterCount: 0))
    textField.text = nil
    clearButton.isHidden = true
  }
}

extension MMTextField: UITextFieldDelegate {
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

    // charactorLimitCount 가 0일 경우 LimitCount 미표기 모드,
    // 에러 상태였더라도 텍스트 입력시 active 상태로 전환
    guard charactorLimitCount != 0 else {
      state = .active
      charactorLimitView.setState(.default(characterCount: 0))
      return true
    }

    // charactorLimitCount 가 0이 아닌 경우 LimitCount 표기 모드,
    // 조건에 따라 에러 상태 해제(리밋 카운트 미만일경우 에러 모드 해제)
    if charactorLimitCount != 0 && charactorLimitCount >= currentText.count {
      state = .active
      charactorLimitView.setState(.default(characterCount: updatedText.count))
    } else if charactorLimitCount != 0 {
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

extension MMTextField {
  public func setError(message: String) {
    guard let textCount = textField.text?.count else { return }
    state = .error
    charactorLimitView.setState(.error(
      characterCount: textCount,
      errorMessage: message
    ))
  }

  public func setIsEnabled(to value: Bool) {
    textField.isEnabled = value

    colorLineView.isHidden = !value
    colorLineView.flex.isIncludedInLayout(value).markDirty()

    charactorLimitView.isHidden = !value
    charactorLimitView.flex.isIncludedInLayout(value).markDirty()
    clearButton.isHidden = !value
    setNeedsLayout()
  }

  public func setText(to text: String) {
    textField.text = text
  }

  public func setTitle(to text: String) {
    titleLabel.text = text
    titleLabel.flex.markDirty()
    setNeedsLayout()
  }

  public func setPlaceholder(to text: String) {
    textField.placeholder = text
  }

  public func setKeyboardType(to type: UIKeyboardType) {
    textField.keyboardType = type
  }

  // asterisk(*) 표기 유무
  public func setRequireMark(to value: Bool = true) {
    asteriskLabel.isHidden = !value
  }
}
