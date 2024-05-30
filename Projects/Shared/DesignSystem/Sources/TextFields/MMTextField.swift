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
  private var condition: ((String) -> Bool)?
  private var errorMessage: String?
  
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
    textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
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
  
  @objc private func textDidChange() {
    guard let inputText = textField.text else { return }
    
    // 글자수 제한이 있을 경우, 애초에 글자수를 넘어가지 않도록 조정
    if charactorLimitCount != 0 && inputText.count >= charactorLimitCount {
      textField.text = String(inputText.prefix(charactorLimitCount))
    }
    
    guard let text = textField.text else { return }
    
    // 유효성에 문제가 있다면 에러처리
    if condition?(text) == false {
      state = .error
      charactorLimitView.setState(.error(characterCount: text.count, errorMessage: errorMessage ?? ""))
    } else {
      state = .active
      charactorLimitView.setState(.default(characterCount: text.count))
    }
  }
}

extension MMTextField: UITextFieldDelegate {
  
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    
    // 유효성에 문제가 있다면 에러처리
    if condition?(text) == false && text.isEmpty == false {
      state = .error
      charactorLimitView.setState(.error(characterCount: text.count, errorMessage: self.errorMessage ?? ""))
    } else {
      state = .active
      charactorLimitView.setState(.default(characterCount: text.count))
    }
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text else { return }
    
    // 유효성에 문제가 있다면 에러처리
    if condition?(text) == false && text.isEmpty == false {
      state = .error
      charactorLimitView.setState(.error(characterCount: text.count, errorMessage: self.errorMessage ?? ""))
    } else {
      state = .unActive
      charactorLimitView.setState(.default(characterCount: text.count))
    }
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else { return true }
    
    // 유효성에 문제가 있다면 에러처리
    if condition?(text) == false && text.isEmpty == false {
      state = .error
      charactorLimitView.setState(.error(characterCount: text.count, errorMessage: self.errorMessage ?? ""))
    } else {
      state = .unActive
      charactorLimitView.setState(.default(characterCount: text.count))
    }
    
    textField.resignFirstResponder()
    return true
  }
}

extension MMTextField {
  public func setIsEnabled(to value: Bool) {
    textField.isEnabled = value

    colorLineView.isHidden = !value
    colorLineView.flex.isIncludedInLayout(value).markDirty()

    charactorLimitView.isHidden = !value
    charactorLimitView.flex.isIncludedInLayout(value).markDirty()
    clearButton.isHidden = !value
    setNeedsLayout()
  }

  @discardableResult
  public func setError(message: String, condition: @escaping (String) -> Bool) -> Self {
    self.errorMessage = message
    self.condition = condition
    return self
  }
  
  @discardableResult
  public func setText(to text: String) -> Self {
    textField.text = text
    return self
  }
  
  @discardableResult
  public func setTitle(to text: String) -> Self {
    titleLabel.text = text
    return self
  }
  
  @discardableResult
  public func setPlaceholder(to text: String) -> Self {
    textField.placeholder = text
    return self
  }
  
  @discardableResult
  public func setKeyboardType(to type: UIKeyboardType) -> Self {
    textField.keyboardType = type
    return self
  }
  
  // asterisk(*) 표기 유무
  @discardableResult
  public func setRequireMark(to value: Bool = true) -> Self {
    asteriskLabel.isHidden = !value
    return self
  }
}
