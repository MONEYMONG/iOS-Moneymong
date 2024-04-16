import UIKit

import DesignSystem

final class TextFieldsVC: UIViewController {

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "내부 textField, textView 접근하여 Binding"
    return label
  }()

  private let input = MMTextField(charactorLimitCount: 20, title: "Input", placeholeder: "플레이스 홀더")

  private let searchBar = MMSearchBar(title: "SearchBar", placeholeder: "플레이스 홀더", didSearch: nil)

  private let textArea = MMTextView(charactorLimitCount: 20, title: "TextArea", placeholeder: "플레이스 홀더")

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
