import UIKit

import DesignSystem

final class AlertVC: UIViewController {
  private let showOkAlertButton: UIButton = {
    var config = UIButton.Configuration.borderedProminent()
    config.title = "show OkAlert"
    return UIButton(configuration: config)
  }()
  
  private let showCanCancelButton: UIButton = {
    var config = UIButton.Configuration.borderedProminent()
    config.title = "show CanCancelAlert"
    return UIButton(configuration: config)
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
    title = "Alert"
    view.backgroundColor = .white
    
    showOkAlertButton.addAction {
      AlertsManager.show(
        title: "메인 타이틀1",
        subTitle: nil,
        type: .onlyOkButton({ print("ok") })
      )
    }
    
    showCanCancelButton.addAction {
      AlertsManager.show(
        title: "메인 타이틀1",
        subTitle: "서브 타이틀2",
        type: .default(okAction: {
          print("ok")
        }, cancelAction: {
          print("cancel")
        })
      )
    }
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.direction(.column).alignItems(.center).define { flex in
      flex.addItem(showCanCancelButton).width(300).marginBottom(10)
      flex.addItem(showOkAlertButton).width(300)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .left().right().vCenter().height(120)
      
    
    rootContainer.flex.layout()
  }

}
