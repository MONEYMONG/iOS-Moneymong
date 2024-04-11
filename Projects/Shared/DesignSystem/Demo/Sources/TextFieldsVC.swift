import UIKit

import DesignSystem

final class TextFieldsVC: UIViewController {

  private let input = Input(charactorLimitCount: 20, title: "Input", placeholeder: "플레이스 홀더")

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
    rootContainer.flex.justifyContent(.center).define { flex in
      flex.addItem(input).marginHorizontal(20)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}
