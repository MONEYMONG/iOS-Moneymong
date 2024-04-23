import UIKit

import DesignSystem
import PinLayout
import FlexLayout

final class LoadingIndicatorViewController: UIViewController {
  private let flexContainer = UIView()

  private let indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = Colors.Blue._4
    return indicator
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setLayouts()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    flexContainer.pin.all()
    flexContainer.flex.layout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    indicator.startAnimating()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    indicator.stopAnimating()
  }

  private func setupViews() {
    view.addSubview(flexContainer)
  }

  private func setLayouts() {
    flexContainer.flex.backgroundColor(UIColor(white: 0, alpha: 0.10))
      .alignItems(.center)
      .justifyContent(.center)
      .define { flex in
        flex.addItem(indicator)
      }
  }
}
