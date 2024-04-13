import UIKit

import DesignSystem
import PinLayout
import FlexLayout

final class LineTabVC: UIViewController {
  
  private let rootContainer = UIView()
  
  private lazy var lineTabViewController: LineTabViewController = {
    let vc = LineTabViewController([vc1, vc2])
    return vc
  }()
  
  private let vc1: UIViewController = {
    let vc = UIViewController()
    vc.title = "장부"
    vc.view.backgroundColor = .white
    return vc
  }()
  
  private let vc2: UIViewController = {
    let vc = UIViewController()
    vc.title = "멤버"
    vc.view.backgroundColor = .green
    return vc
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    title = "LineTab"
    view.backgroundColor = .white
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(lineTabViewController.view)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
}
