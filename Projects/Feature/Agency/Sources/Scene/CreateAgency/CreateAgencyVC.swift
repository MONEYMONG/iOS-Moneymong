import UIKit
import Combine

import DesignSystem
import BaseFeature

import RxSwift
import RxCocoa
import ReactorKit
import FlexLayout
import PinLayout

final class CreateAgencyVC: BaseVC, View {
  weak var coordinator: AgencyCoordinator?
  var disposeBag = DisposeBag()
  private var cancelBag = Set<AnyCancellable>()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "동아리 or 학생회 등록에\n필요한 항목들을 채워주세요.", lineHeight: 28)
    v.numberOfLines = 2
    v.textColor = Colors.Gray._10
    v.font = Fonts.heading._2
    return v
  }()
  
  private let segmentTitleLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "소속 유형", lineHeight: 18)
    v.textColor = Colors.Gray._6
    v.font = Fonts.body._2
    return v
  }()
  
  private let agencySegmentControl: MMSegmentControl = {
    let v = MMSegmentControl(titles: ["동아리", "학생회"], type: .round)
    v.selectedIndex = 0
    return v
  }()
  
  private let agencyTextField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 20, title: "소속 이름")
    v.setPlaceholder(to: "소속 이름을 입력해주세요.")
    return v
  }()
  
  private let createButton: MMButton = MMButton(title: "등록하기", type: .disable)
  
  override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.paddingHorizontal(20).define { flex in
      flex.addItem(titleLabel).marginBottom(40)
      flex.addItem(segmentTitleLabel).marginBottom(8)
      flex.addItem(agencySegmentControl).marginBottom(40)
      flex.addItem(agencyTextField)
      flex.addItem().grow(1)
      flex.addItem(createButton).height(56).marginBottom(12)
    }
  }
  
  func bind(reactor: CreateAgencyReactor) {
    setRightItem(.closeBlack)
    // Action
    navigationItem.rightBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.alert(
          title: "정말 나가시겠습니까?",
          subTitle: "입력하신 내용은 저장되지 않습니다.",
          okAction: {
            owner.coordinator?.dismiss()
          })
        )
      }
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
    
    agencySegmentControl.$selectedIndex
      .sink { [weak self] in
        self?.reactor?.action.onNext(.selectedIndexDidChange($0))
      }
      .store(in: &cancelBag)
    
    createButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.tapCreateButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State
    reactor.pulse(\.$isButtonEnabled)
      .bind(with: self) { owner, value in
        owner.createButton.setState(value ? .primary : .disable)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        switch value {
        case .complete:
          owner.coordinator?.push(.createComplete)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.coordinator?.present(.alert(
          title: "등록에 실패했습니다",
          subTitle: nil,
          okAction: { }
        ))
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
  }
}
