import UIKit

import DesignSystem
import BaseFeature

import PinLayout
import FlexLayout
import ReactorKit

final class CreateCategoryVC: BaseVC, View {
  var disposeBag = DisposeBag()
  
  private var keybordShowCreateButtonConstraints: [NSLayoutConstraint] = []
  private var keybordHideCreateButtonConstraints: [NSLayoutConstraint] = []
  
  private let backButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.chevronLeft, for: .normal)
    return v
  }()
  
  private let categoryField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 10)
      .setPlaceholder(to: "카테고리를 입력해주세요")
      .setRequireMark(to: false)
    v.textField.autocorrectionType = .no
    v.textField.spellCheckingType = .no
    v.textField.autocapitalizationType = .none
    return v
  }()
  
  private let registerButton: MMButton = MMButton(title: "등록하기", type: .disable)
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    categoryField.textField.becomeFirstResponder()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem().direction(.row).define { flex in
        flex.addItem(backButton).alignSelf(.start).marginRight(8)
        flex.addItem(UILabel().text("카테고리 생성", font: Fonts.heading._1, color: .black))
      }.marginBottom(16)
      flex.addItem(categoryField)
    }
    .paddingHorizontal(16)
    .paddingVertical(20)
    
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
  
  func bind(reactor: CreateCategoryReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
  
  private func bindAction(_ reactor: CreateCategoryReactor) {
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
    
    backButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    categoryField.textField.rx.text
      .skip(1)
      .compactMap { $0 }
      .map { Reactor.Action.inputTitle($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    registerButton.rx.tap
      .map { Reactor.Action.didTapRegisterButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(_ reactor: CreateCategoryReactor) {
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .before:
          owner.navigationController?.popViewController(animated: true)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$title)
      .map { $0.isEmpty || $0 == "" }
      .bind(with: self) { owner, isDisabled in
        owner.registerButton.setState(isDisabled ? .disable : .primary)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$textFieldError)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, message in
        owner.categoryField.setError(message: message)
      }
      .disposed(by: disposeBag)
  }
}
