import UIKit

import FlexLayout
import PinLayout

public final class MMLodingIndicatorVC: UIViewController {
  private let rootContainer = UIView()

  private let indicator = MMIndicator()

  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    indicator.startAnimating()
  }

  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    indicator.stopAnimating()
  }

  private func setupView() {
    view.addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex
      .alignItems(.center)
      .justifyContent(.center)
      .define { flex in
        flex.addItem(indicator)
      }
  }
}
