import UIKit
import Combine

import DesignSystem
import BaseFeature
import CreateAgencyInterface

import RxSwift
import RxCocoa
import ReactorKit

public final class InputAgencyInfoVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  private var cancelBag = Set<AnyCancellable>()
  
  private let createCompleteFactory: CreateCompleteFactoryInterface
  private let inputUniversityInfoFactory: InputUniversityInfoFactoryInterface
  
  private var keybordShowCreateButtonConstraints: [NSLayoutConstraint] = []
  private var keybordHideCreateButtonConstraints: [NSLayoutConstraint] = []

  public var coordinator: CreateAgencyCoordinator?
  
  init(
    createCompleteFactory: CreateCompleteFactoryInterface,
    inputUniversityInfoFactory: InputUniversityInfoFactoryInterface
  ) {
    self.createCompleteFactory = createCompleteFactory
    self.inputUniversityInfoFactory = inputUniversityInfoFactory
    super.init()
  }
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "회비 관리가 필요한\n소속 정보를 알려주세요!", lineHeight: 28)
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
    let v = MMSegmentControl(titles: ["동아리", "학생회", "기타모임"], type: .round)
    v.selectedIndex = 0
    return v
  }()
  
  private let agencyTextField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 20, title: "소속 이름")
    v.setPlaceholder(to: "소속 이름을 입력해주세요.")
    return v
  }()
  
  private let createButton: MMButton = MMButton(title: "등록하기", type: .disable)
  
  public override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.paddingHorizontal(20).define { flex in
      flex.addItem(titleLabel).marginBottom(40)
      flex.addItem(segmentTitleLabel).marginBottom(8)
      flex.addItem(agencySegmentControl).marginBottom(40)
      flex.addItem(agencyTextField)
      flex.addItem().grow(1)
    }
    
    view.addSubview(createButton)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    
    keybordHideCreateButtonConstraints = [
      createButton.heightAnchor.constraint(equalToConstant: 56),
      createButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
      createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
      createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12)
    ]
    
    keybordShowCreateButtonConstraints = [
      createButton.heightAnchor.constraint(equalToConstant: 56),
      createButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
      createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 3),
      createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -3)
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
          owner.createButton.layer.cornerRadius = 0
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
          owner.createButton.layer.cornerRadius = 12
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
            owner.dismiss(animated: true)
          }, cancelAction: {
            
          })
        )
      }
      .disposed(by: disposeBag)
    
    view.rx.tapGesture
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
    
    // State Binding
    reactor.pulse(\.$universityType)
      .filter { $0 == .none}
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.agencySegmentControl.selectedIndex = 2
        owner.agencySegmentControl.disableButtons(with: 0,1)
        owner.agencySegmentControl.flex.layout()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isButtonEnabled)
      .bind(with: self) { owner, value in
        owner.createButton.setState(value ? .primary : .disable)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        guard let coordinator = owner.coordinator else { return }
        switch value {
        case let .complete(id):
          let vc = owner.createCompleteFactory.make(coordinator: coordinator, id: id)
          owner.navigationController?.pushViewController(vc, animated: true)
        case let .inputUniversity(agencyName, agencyType):
          let vc = owner.inputUniversityInfoFactory.make(coordinator: coordinator, agencyName: agencyName, agencyType: agencyType)
          owner.navigationController?.pushViewController(vc, animated: true)
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
