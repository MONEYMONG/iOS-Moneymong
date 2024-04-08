import UIKit

import DesignSystem
//import FlexLayout
//import PinLayout

final class SnackBarVC: UIViewController {
  private let defaultButton: UIButton = {
    var config = UIButton.Configuration.borderedProminent()
    config.title = "일반 토스트"
    return UIButton(configuration: config)
  }()
  
  private let retryButton: UIButton = {
    var config = UIButton.Configuration.borderedProminent()
    config.title = "retry 토스트"
    config.baseBackgroundColor = .red
    return UIButton(configuration: config)
  }()
  
  private let retryLabel: UILabel = {
    let v = UILabel()
    v.text = "뭔가 리트라이..!"
    v.textColor = .red
    return v
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
    
    defaultButton.addAction { [weak self] in
      SnackBarManager.show(title: "단순 내용입니다")
    }
    
    retryButton.addAction { [weak self] in
      SnackBarManager.show(title: "다시 시도해주세요") {
        debugPrint("RETRY!")
      }
    }
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.direction(.row).justifyContent(.center).padding(10).define { flex in
      flex.addItem(defaultButton).width(150).marginRight(10)
      flex.addItem(retryButton).width(150)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin
      .left().right().vCenter()
      .height(60)
    
    rootContainer.flex.layout()
  }
}
