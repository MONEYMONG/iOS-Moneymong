import UIKit

import DesignSystem

final class IndicatorVC: UIViewController {

  private let indicator: MMIndicator = {
    let indicator = MMIndicator()
    indicator.startAnimating()
    return indicator
  }()

  private let startButton: MMButton = {
    let button = MMButton(title: "Start", type: .primary)
    return button
  }()

  private let stopButton: MMButton = {
    let button = MMButton(title: "Stop", type: .primary)
    return button
  }()

  private let rootContainer = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    setupConstraints()
  }

  private func setupView() {
    view.backgroundColor = .white
    startButton.addTarget(
      self,
      action: #selector(didTapStartButton),
      for: .touchUpInside
    )

    stopButton.addTarget(
      self,
      action: #selector(didTapStopButton),
      for: .touchUpInside
    )
  }

  private func setupConstraints() {
    view.addSubview(rootContainer)

    rootContainer.flex.define { flex in
      flex.addItem().grow(1)

      flex.addItem(indicator).alignSelf(.center)

      flex.addItem().grow(1)

      flex.addItem()
        .direction(.row)
        .paddingHorizontal(20)
        .define { flex in
          flex.addItem(startButton).height(56).grow(1)
          flex.addItem().width(10)
          flex.addItem(stopButton).height(56).grow(1)
        }

      flex.addItem().height(100)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  @objc private func didTapStartButton() {
    indicator.startAnimating()
  }

  @objc private func didTapStopButton() {
    indicator.stopAnimating()
  }
}
