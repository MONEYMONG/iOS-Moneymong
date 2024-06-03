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
  
  public var textView: UITextView = {
    let textView = UITextView()
    textView.font = Fonts.body._3
    textView.selectedTextRange = nil
    textView.isScrollEnabled = false
    textView.textColor = Colors.Gray._8
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
  
  public init(charactorLimitCount: Int = 0, title: String) {
    self.state = .unActive
    self.charactorLimitCount = charactorLimitCount
    self.charactorLimitView = CharacterLimitView(
      state: .default(characterCount: 0),
      limitCount: charactorLimitCount
    )
    self.charactorLimitView.isHidden = charactorLimitCount == 0
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
    rootContainer.flex.layout(mode: .adjustHeight)
  }
  
  private func setupView(with title: String) {
    addSubview(rootContainer)
    titleLabel.text = title
    textView.delegate = self
  }
  
  private func setupConstraints() {
    rootContainer.flex.backgroundColor(.white).define { flex in
      flex.addItem(titleLabel)
      
      flex.addItem().direction(.row).define { flex in
        flex.addItem(textView).backgroundColor(.white).minHeight(150).grow(1)
        flex.addItem(placeholderLabel).position(.absolute).top(8).left(3)
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
    guard let inputText = textView.text else { return }

    // 글자수 제한이 있을 경우, 애초에 글자수를 넘어가지 않도록 조정
    if charactorLimitCount != 0 && inputText.count >= charactorLimitCount {
      textView.text = String(inputText.prefix(charactorLimitCount))
    }
    
    charactorLimitView.setState(.default(characterCount: textView.text.count))
    placeholderLabel.isHidden = !textView.text.isEmpty

    textView.flex.height(textView.intrinsicContentSize.height)
    textView.flex.markDirty()
    setNeedsLayout()
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    state = .active
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    state = .unActive
  }
}

extension MMTextView {
  @discardableResult
  public func setText(to text: String) -> Self {
    placeholderLabel.isHidden = !text.isEmpty
    textView.text = text
    return self
  }
  
  @discardableResult
  public func setPlaceholder(to text: String) -> Self {
    placeholderLabel.text = text
    return self
  }
}
