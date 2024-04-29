import UIKit

import BaseFeature
import Utility
import DesignSystem

import ReactorKit
import PinLayout
import FlexLayout

public final class WithdrawalVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "탈퇴하시겠어요?", lineHeight: 28)
    v.font = Fonts.heading._1
    v.textColor = Colors.Red._3
    return v
  }()
  
  private let contentLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "본인이 소속된 기관의 장부 기록 내역은 삭제되지 않습니다. 그 외의 이용내역은 삭제되며, 복원이 불가능합니다.", lineHeight: 28)
    v.numberOfLines = 0
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._7
    return v
  }()
  
  private let checkBoxButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.checkbox, for: .normal)
    v.setImage(Images.checkboxFill, for: .selected)
    return v
  }()
  
  private let agreementLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "해당 내용에 동의하시겠습니까?", lineHeight: 20)
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._7
    return v
  }()
  
  private let withdrawalButton = MMButton(title: "탈퇴하기", type: .disable)
  
  public override func setupUI() {
    super.setupUI()
    
    setTitle("회원탈퇴")
    setLeftItem(.back)
  }
  
  public override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.padding(20).direction(.column).define { flex in
      flex.addItem().define { flex in
        flex.addItem(titleLabel)
          .marginBottom(4)
        flex.addItem(contentLabel)
          .marginBottom(16)
        flex.addItem(UIView()).height(1).backgroundColor(Colors.Gray._2)
          .marginBottom(16)
        flex.addItem().direction(.row).define { flex in
          flex.addItem(checkBoxButton)
            .marginRight(8)
          flex.addItem(agreementLabel)
        }
      }
      .padding(20, 16)
      .border(1, Colors.Gray._3).cornerRadius(12)
      
      flex.addItem(UIView()).grow(1)
      flex.addItem(withdrawalButton).height(56)
    }
  }
  
  public func bind(reactor: WithdrawalReactor) {
    // Action Binding
    navigationItem.leftBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    checkBoxButton.rx.tap
      .map { Reactor.Action.tapAgreementButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    withdrawalButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.presentAlert(
          title: "정말 탈퇴 하시겠습니까?",
          subTitle: "탈퇴시 계정은 삭제되며 복구되지 않습니다",
          okAction: {
            reactor.action.onNext(.tapWithdrawlButton)
          }
        )
      }
      .disposed(by: disposeBag)
    
    // Data Binding
    reactor.pulse(\.$isAgree)
      .subscribe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.checkBoxButton.isSelected = value
        owner.withdrawalButton.setState(value ? .primary : .disable)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .subscribe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        // TODO: 로그인으로 이동
      }
      .disposed(by: disposeBag)
  }
}
