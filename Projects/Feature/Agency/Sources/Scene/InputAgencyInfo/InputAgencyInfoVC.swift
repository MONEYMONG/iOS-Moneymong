import UIKit
import Combine

import DesignSystem
import BaseFeature

import RxSwift
import RxCocoa
import ReactorKit

public final class InputAgencyInfoVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  private var cancelBag = Set<AnyCancellable>()
  
  private var keybordShowCreateButtonConstraints: [NSLayoutConstraint] = []
  private var keybordHideCreateButtonConstraints: [NSLayoutConstraint] = []
  
  public var coordinator: CreateAgencyCoordinator?
  
  private let agencyTextField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 20, title: "장부")
    v.setPlaceholder(to: "ex) 제주도 여행")
    return v
  }()
  
  private let registerButton: MMButton = MMButton(title: "등록하기", type: .disable)
  
  public override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.paddingHorizontal(20).define { flex in
      flex.addItem(UILabel().text("장부 생성하기", font: Fonts.heading._5, color: Colors.Gray._10))
        .marginTop(16)
        .marginBottom(12)
      flex.addItem(UILabel().text("사용할 장부는 언제든지 추가로 만들 수 있어요", font: Fonts.body._3, color: Colors.Gray._5))
        .marginBottom(16)
      flex.addItem(agencyTextField).marginTop(28)
      flex.addItem().grow(1)
    }
    
    view.addSubview(registerButton)
    registerButton.translatesAutoresizingMaskIntoConstraints = false
    
    keybordHideCreateButtonConstraints = [
      registerButton.heightAnchor.constraint(equalToConstant: 56),
      registerButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
      registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
      registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12)
    ]
    
    keybordShowCreateButtonConstraints = [
      registerButton.heightAnchor.constraint(equalToConstant: 56),
      registerButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
      registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 12),
      registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -12)
    ]
    
    NSLayoutConstraint.activate(keybordHideCreateButtonConstraints)
  }
  
  public func bind(reactor: InputAgencyInfoReactor) {
    // Action Binding
    setRightItem(.closeBlack)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        UIView.animate(withDuration: 0.2) {
          NSLayoutConstraint.deactivate(owner.keybordHideCreateButtonConstraints)
          NSLayoutConstraint.activate(owner.keybordShowCreateButtonConstraints)
        }
        
        UIView.animate(withDuration: 0.2) {
          owner.registerButton.layer.cornerRadius = 0
        }
        owner.view.layoutIfNeeded()
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        UIView.animate(withDuration: 0.2) {
          NSLayoutConstraint.deactivate(owner.keybordShowCreateButtonConstraints)
          NSLayoutConstraint.activate(owner.keybordHideCreateButtonConstraints)
        }
        
        UIView.animate(withDuration: 0.2) {
          owner.registerButton.layer.cornerRadius = 12
        }
        owner.view.layoutIfNeeded()
      }
      .disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        AlertsManager.show(
          title: "정말 나가시겠습니까?",
          subTitle: "입력하신 내용은 저장되지 않습니다.",
          type: .default(okAction: {
            owner.reactor?.action.onNext(.dismiss)
          }, cancelAction: {
            
          })
        )
      }
      .disposed(by: disposeBag)
    
    rootContainer.rx.tapGesture
      .bind { $0.endEditing(true) }
      .disposed(by: disposeBag)
    
    agencyTextField.textField.rx.text
      .compactMap { $0 }
      .map { Reactor.Action.textFieldDidChange($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    agencyTextField.clearButton.rx.tap
      .map { Reactor.Action.textFieldDidChange("") }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    registerButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.tapCreateButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State Binding
    reactor.pulse(\.$isButtonEnabled)
      .bind(with: self) { owner, value in
        owner.registerButton.setState(value ? .primary : .disable)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .main:
          owner.coordinator?.dismiss()
          owner.coordinator?.move(to: .main)
        case .dismiss:
          owner.coordinator?.dismiss()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        AlertsManager.show(
          title: "등록에 실패했습니다",
          subTitle: nil,
          type: .onlyOkButton({})
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
  }
}
