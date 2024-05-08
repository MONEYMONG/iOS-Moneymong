import UIKit

import DesignSystem

final class TextFieldsVC: UIViewController {

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "내부 textField, textView 접근하여 Binding"
    return label
  }()

  private let input: MMTextField = {
    let input = MMTextField(charactorLimitCount: 0, title: "Input")
    input.setRequireMark()
    input.setPlaceholder(to: "플레이스 홀더")
    return input
  }()

  private let inputErrorButton: MMButton = {
    let button = MMButton(title: "Input 강제로 에러상태로 전환", type: .secondary)
    return button
  }()

  private let searchBar: MMSearchBar = {
    let searchBar = MMSearchBar(title: "SearchBar", didSearch: nil)
    searchBar.setPlaceholder(to: "플레이스 홀더")
    return searchBar
  }()

  private let textArea: MMTextView = {
    let textView = MMTextView(charactorLimitCount: 20, title: "TextArea")
    textView.setPlaceholder(to: "플레이스 홀더")
    return textView
  }()

  private let textAreaErrorButton: MMButton = {
    let button = MMButton(title: "TextArea 강제로 에러상태로 전환", type: .secondary)
    return button
  }()

  private let rootContainer = UIView()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    view.backgroundColor = .white
    title = "TextFields"

    inputErrorButton.addTarget(
      self,
      action: #selector(didTapInputError),
      for: .touchUpInside
    )
    textAreaErrorButton.addTarget(
      self,
      action: #selector(didTapTextAreaError),
      for: .touchUpInside
    )
  }

  private func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.justifyContent(.center).paddingHorizontal(20).define { flex in
      flex.addItem(descriptionLabel)

      flex.addItem().height(20)

      flex.addItem(input)
      flex.addItem().height(10)
      flex.addItem(inputErrorButton)

      flex.addItem().height(40)

      flex.addItem(searchBar)

      flex.addItem().height(40)

      flex.addItem(textArea)
      flex.addItem().height(10)
      flex.addItem(textAreaErrorButton)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  @objc private func didTapInputError() {
    input.setError(message: "앗! 에러 발생!")
  }

  @objc private func didTapTextAreaError() {
    textArea.setError(message: "앗! 에러 발생!")
  }
}
