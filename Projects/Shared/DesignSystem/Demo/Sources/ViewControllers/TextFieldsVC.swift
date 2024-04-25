import UIKit

import DesignSystem

final class TextFieldsVC: UIViewController {

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "내부 textField, textView 접근하여 Binding"
    return label
  }()

  private let input: MMTextField = {
    let input = MMTextField(charactorLimitCount: 20, title: "Input")
    input.setRequireMark()
    input.setPlaceholder(to: "플레이스 홀더")
    return input
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
  }

  private func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.justifyContent(.center).paddingHorizontal(20).define { flex in
      flex.addItem(descriptionLabel)

      flex.addItem().height(20)

      flex.addItem(input)

      flex.addItem().height(40)

      flex.addItem(searchBar)

      flex.addItem().height(40)

      flex.addItem(textArea)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}
