import UIKit

import BaseFeature
import DesignSystem
import Utility

import ReactorKit
import RxCocoa

final class JoinAgencyVC: BaseVC, ReactorKit.View {
  var disposeBag = DisposeBag()
  var coordinator: JoinAgencyCoordinator?
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "초대코드를 입력해주세요", lineHeight: 30)
    v.numberOfLines = 0
    v.textColor = Colors.Gray._10
    v.textAlignment = .left
    v.font = Fonts.heading._3
    return v
  }()
  
  private let inviteCodeLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "초대코드", lineHeight: 18)
    v.textColor = Colors.Blue._4
    v.font = Fonts.body._2
    v.textAlignment = .center
    return v
  }()
  
  private let codeviews: [CodeView] = [
    CodeView(state: .focused),
    CodeView(state: .plain),
    CodeView(state: .plain),
    CodeView(state: .plain),
    CodeView(state: .plain),
    CodeView(state: .plain)
  ]
  
  private let navigationType: NavigationType
  
  init(navigationType: NavigationType) {
    self.navigationType = navigationType
    super.init()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    let width = (UIScreen.main.bounds.width - 50 - 40) / 6
    let height = width * 72/45
    
    rootContainer.flex.justifyContent(.center).marginHorizontal(20).define { flex in
      flex.addItem(titleLabel).position(.absolute).top(8)
      
      flex.addItem().paddingBottom(100).define { flex in
        flex.addItem(inviteCodeLabel).width(width).marginBottom(8)
        flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
          codeviews.forEach {
            flex.addItem($0).width(width).height(height)
          }
        }
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    codeviews[0].numberTextField.becomeFirstResponder()
  }
  
  func bind(reactor: JoinAgencyReactor) {
    if navigationType == .present {
      setRightItem(.closeBlack)
    } else {
      setLeftItem(.back)
    }
    
    navigationItem.rightBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss()
      }
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    view.rx.tapGesture
      .bind { $0.endEditing(true) }
      .disposed(by: disposeBag)
    
    codeviews.enumerated().forEach { index, codeView in
      codeView.delegate = self
    }
    
    reactor.pulse(\.$codes)
      .distinctUntilChanged()
      .filter { $0.joined().count == 6 }
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      .do { [weak self] _ in self?.view.endEditing(true) }
      .map { _ in Reactor.Action.requestJoinAgency}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$snackBarMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, message in
        owner.codeviews.forEach { $0.setState(.error) }
        
        SnackBarManager.show(title: message) {
          owner.reactor?.action.onNext(.tapRetryButton)
          owner.codeviews.enumerated().forEach { index, codeView in
            codeView.numberTextField.text = ""
            codeView.setState(index == 0 ? .focused : .plain)
          }
          owner.codeviews[0].numberTextField.becomeFirstResponder()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, message in
        owner.coordinator?.present(.alert(title: message))
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .ledger:
          owner.coordinator?.dismiss()
          owner.coordinator?.move(to: .ledger)
        }
      }
      .disposed(by: disposeBag)
  }
}

extension JoinAgencyVC: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.selectedTextRange = nil
  }
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard string.isEmpty || Int(string) != nil else { return false }
    guard let idx = codeviews.map(\.numberTextField).firstIndex(of: textField) else { return false }
    
    if let text = textField.text, !text.isEmpty, !string.isEmpty {
      guard idx < codeviews.count - 1 else { return false }
      codeviews[idx+1].numberTextField.becomeFirstResponder()
      codeviews[idx+1].numberTextField.text = string
      reactor?.action.onNext(.textFieldDidChange(text: string, index: idx+1))
      codeviews[idx+1].setState(.done)
      if idx < codeviews.count - 2 {
        codeviews[idx+2].setState(.focused)
      }
      return false
    }
    
    if string.isEmpty {
      textField.text = ""
      reactor?.action.onNext(.textFieldDidChange(text: "", index: idx))
      codeviews.forEach {
        if $0.state == .focused {
          $0.setState(.plain)
        }
      }
      codeviews[idx].setState(.focused)
      
      if idx > 0 {
        let prevField = codeviews[idx-1].numberTextField
        prevField.becomeFirstResponder()
        prevField.selectedTextRange = prevField.textRange(from: prevField.endOfDocument, to: prevField.endOfDocument)
      }
      return false
    } else if string.count > 1 {
      let numbers = string.compactMap { $0.isNumber ? String($0) : nil }
      guard !numbers.isEmpty else { return false }
      
      for (index, number) in numbers.prefix(6).enumerated() {
        let codeview = codeviews[index]
        codeview.numberTextField.text = number
        reactor?.action.onNext(.textFieldDidChange(text: number, index: index))
        codeview.setState(.done)
      }
      
      let nextIndex = min(codeviews.count - 1, idx + numbers.count)
      let lastTextField = codeviews[nextIndex].numberTextField
      lastTextField.becomeFirstResponder()
      lastTextField.selectedTextRange = lastTextField.textRange(from: lastTextField.endOfDocument, to: lastTextField.endOfDocument)
      return false
    }
    
    codeviews[idx].setState(.done)
    if idx < codeviews.count - 1 {
      codeviews[idx+1].setState(.focused)
    }
    reactor?.action.onNext(.textFieldDidChange(text: string, index: idx))
    return true
  }
}
