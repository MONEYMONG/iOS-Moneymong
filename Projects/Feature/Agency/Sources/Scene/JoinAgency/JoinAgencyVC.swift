import UIKit

import BaseFeature
import DesignSystem
import Utility

import ReactorKit
import RxCocoa

final class JoinAgencyVC: BaseVC, ReactorKit.View {
  var disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.numberOfLines = 2
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
  
  override func setupUI() {
    super.setupUI()
    
    if let agencyName = reactor?.currentState.agencyName {
      titleLabel.setTextWithLineHeight(text: "\(agencyName)에서 받은\n초대코드를 입력해주세요", lineHeight: 30)
      titleLabel.flex.markDirty()
      titleLabel.setNeedsLayout()
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    let width = (UIScreen.main.bounds.width - 50 - 40) / 6
    let height = width * 72/45
    
    rootContainer.flex.justifyContent(.center).marginHorizontal(20).define { flex in
      flex.addItem(titleLabel).position(.absolute).top(8)
      
      flex.addItem().define { flex in
        flex.addItem(inviteCodeLabel).width(width).marginBottom(8)
        flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
          codeviews.forEach {
            flex.addItem($0).width(width).height(height)
          }
        }
      }
    }
  }
  
  func bind(reactor: JoinAgencyReactor) {
    setRightItem(.closeBlack)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss()
      }
      .disposed(by: disposeBag)
    
    codeviews.enumerated().forEach { index, codeView in
      codeView.numberTextField.rx.text
        .orEmpty.skip(1)
        .map { Reactor.Action.textFieldDidChange(text: $0, index: index)}
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    codeviews.indices.forEach { index in
      reactor.pulse(\.$codes)
        .map { $0[index] }
        .distinctUntilChanged()
        .observe(on: MainScheduler.instance)
        .bind(with: self) { owner, code in
          owner.codeviews[index].numberTextField.text = code
          
          if code.isEmpty {
            owner.codeviews[index].setState(.plain)
          } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              owner.codeviews[index].setState(.done)
              owner.codeviews[safe: index+1]?.setState(.focused)
  
              if !owner.codeviews.indices.contains(index+1) {
                owner.view.endEditing(true)
              }
            }
          }
        }
        .disposed(by: disposeBag)
    }
    
    reactor.pulse(\.$codes)
      .distinctUntilChanged()
      .filter { $0.joined().count == 6 }
      .delay(.seconds(1), scheduler: MainScheduler.instance)
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
        }
      }
      .disposed(by: disposeBag)
      
    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, message in
        owner.coordinator?.present(
          .alert(title: message, subTitle: nil, okAction: {})
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .joinComplete:
          owner.coordinator?.present(.joinComplete)
        }
      }
      .disposed(by: disposeBag)
  }
}
