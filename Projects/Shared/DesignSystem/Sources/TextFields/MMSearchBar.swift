import UIKit

import PinLayout
import FlexLayout

public class MMSearchBar: UIView {

  public enum State {
    case active
    case unActive

    var color: UIColor {
      switch self {
      case .active: return Colors.Blue._4
      case .unActive: return Colors.Gray._6
      }
    }
  }

  private var state: State {
    didSet { updateState() }
  }

  // Keyboard Return, Search Button 입력시 호출
  // Default Return Action = 키보드 비활성화, Default Search Button Action = empty
  private let didSearch: ((String) -> Void)?

  private let rootContainer = UIView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._2
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

  private let searchButton: TouchAreaButton = {
    let button = TouchAreaButton(dx: -10, dy: 0)
    button.setImage(
      Images.search?.withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    button.setImage(
      Images.search?.withRenderingMode(.alwaysTemplate),
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

  public init(
    title: String,
    didSearch: ((String) -> Void)?
  ) {
    self.state = .unActive
    self.didSearch = didSearch
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
    searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
  }

  private func setupConstraints() {
    rootContainer.flex.direction(.column).height(56).define { flex in
      flex.addItem(titleLabel)
      flex.addItem().height(8)

      flex.addItem().direction(.row).define { flex in
        flex.addItem(textField).grow(1)
        flex.addItem(searchButton).width(20).height(20)
      }

      flex.addItem().height(10)
      flex.addItem(colorLineView).height(1).backgroundColor(state.color)
    }
  }

  private func updateState() {
    titleLabel.textColor = state.color
    colorLineView.backgroundColor = state == .unActive ? Colors.Gray._2 : state.color
    textField.tintColor = state.color
  }

  @objc private func didTapSearchButton() {
    didSearch?(textField.text ?? "")
  }
}

extension MMSearchBar: UITextFieldDelegate {
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    state = .active
    return true
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    state = .unActive
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if didSearch == nil {
      textField.resignFirstResponder()
    } else {
      didSearch?(textField.text ?? "")
    }
    return true
  }
}

extension MMSearchBar {
  public func setPlaceholder(to text: String) {
    textField.placeholder = text
  }
}
