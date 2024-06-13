import UIKit

import PinLayout
import FlexLayout
public final class MMAlerts: UIViewController {
  public enum `Type` {
    case onlyOkButton(() -> Void = {})
    case `default`(okAction: () -> Void = {}, cancelAction: () -> Void = {})
  }
  
  private let icon: UIImageView = {
    let v = UIImageView()
    v.image = Images.warningFill
    return v
  }()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._10
    v.font = Fonts.heading._1
    v.text = "메인 타이틀"
    v.textAlignment = .center
    v.numberOfLines = 0
    return v
  }()
  
  private let subTitleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    v.font = Fonts.body._4
    v.text = "서브 타이틀"
    v.textAlignment = .center
    v.numberOfLines = 0
    return v
  }()
  
  private let okButton = MMButton(
    title: "확인",
    type: .primary
  )
  
  private let cancelButton = MMButton(
    title: "취소",
    type: .negative
  )
  
  private let rootContainer = UIView()
  
  init(
    title: String,
    subTitle: String?,
    type: `Type`
  ) {
    super.init(nibName: nil, bundle: nil)
    setupView()
    setupConstraints(
      isSubTitleHidden: subTitle == nil || subTitle!.isEmpty,
      type: type
    )
    titleLabel.text = title
    subTitleLabel.text = subTitle
    switch type {
    case .onlyOkButton(let action):
      okButton.addAction {
        self.dismiss(animated: true)
        action()
      }
    case .default(let okAction, let cancelAction):
      okButton.addAction {
        self.dismiss(animated: true)
        okAction()
      }
      cancelButton.addAction {
        self.dismiss(animated: true)
        cancelAction()
      }
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupView() {
    view.backgroundColor = Colors.Gray._10.withAlphaComponent(0.7)
  }
  
  private func setupConstraints(
    isSubTitleHidden: Bool,
    type: `Type`
  ) {
    view.addSubview(rootContainer)
    
    rootContainer.flex
      .alignItems(.center)
      .justifyContent(.center)
      .backgroundColor(.clear)
      .define { flex in
        flex.addItem()
          .cornerRadius(20)
          .width(335)
          .padding(22)
          .backgroundColor(Colors.White._1)
          .alignItems(.center)
          .define { flex in
          flex.addItem(icon).size(60).marginBottom(10)
          flex.addItem(titleLabel).marginBottom(4)
          if !isSubTitleHidden {
            flex.addItem(subTitleLabel)
          }
            flex.addItem()
              .direction(.row)
              .marginTop(14)
              .define { flex in
                switch type {
                case .onlyOkButton(_):
                  flex.addItem(okButton).width(100%).height(56)
                case .default(_, _):
                  flex.addItem(cancelButton).width(50%).height(56).marginRight(12)
                  flex.addItem(okButton).width(50%).height(56)
                }
              }
          }
      }
  }
}

