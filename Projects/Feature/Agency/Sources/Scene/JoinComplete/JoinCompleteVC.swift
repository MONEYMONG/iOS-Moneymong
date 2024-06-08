import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import FlexLayout
import PinLayout

final class JoinCompleteVC: BaseVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?
  
  private let iconImageView = UIImageView(image: Images.congrats)
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._10
    v.font = Fonts.heading._1
    v.setTextWithLineHeight(text: "가입을 축하합니다!", lineHeight: 28)
    return v
  }()
  
  private let descriptionLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._5
    v.font = Fonts.body._4
    v.setTextWithLineHeight(text: "이제 동아리 가계부를 확인할 수 있어요", lineHeight: 24)
    return v
  }()
  
  private let confirmButton = MMButton(title: "확인하러 가기", type: .primary)
  
  override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.define { flex in
      flex.addItem().justifyContent(.center).alignItems(.center).define { flex in
        flex.addItem(iconImageView).size(100).marginBottom(8)
        flex.addItem(titleLabel).marginBottom(4)
        flex.addItem(descriptionLabel)
      }.grow(1)
      flex.addItem(confirmButton).height(56)
    }.marginHorizontal(20)
  }
  
  func bind(reactor: JoinCompleteReactor) {
    setTitle("가입완료")
    setRightItem(.closeBlack)
    
    // Action
    navigationItem.rightBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss()
      }
      .disposed(by: disposeBag)
    
    confirmButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss(animated: false)
        owner.coordinator?.goLedger()
      }
      .disposed(by: disposeBag)
  }
}
