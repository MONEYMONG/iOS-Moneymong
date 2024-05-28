import UIKit

import BaseFeature
import DesignSystem
import NetworkService

import ReactorKit
import PinLayout
import FlexLayout

final class LedgerDetailVC: BaseVC, View {

  public var disposeBag = DisposeBag()

  weak var coordinator: LedgerCoordinator?

  private let contentsView: LedgerContentsView

  private let editButtonContainer: UIView = {
    let view = UIView()
    view.setShadow(location: .top, color: Colors.Gray._4)
    return view
  }()

  private let editButton = MMButton(title: Const.edit, type: .primary)

  init(contentsView: LedgerContentsView) {
    self.contentsView = contentsView
    super.init()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    rootContainer.pin.top(view.pin.safeArea).left().right().bottom()
    rootContainer.flex.layout()
  }
  override func setupUI() {
    super.setupUI()
    view.backgroundColor = Colors.Gray._1
  }

  override func setupConstraints() {
    super.setupConstraints()

    rootContainer.flex.define { flex in
      flex.addItem(contentsView)
        .grow(1)
        .shrink(1)

      if reactor?.currentState.role == .staff {
        flex.addItem(editButtonContainer)
          .paddingHorizontal(20)
          .backgroundColor(Colors.White._1)
          .define { flex in
            flex.addItem().height(20)
            flex.addItem(editButton).height(56)
            flex.addItem().height(46)
          }
      }
    }
  }

  public func bind(reactor: LedgerDetailReactor) {
    rx.viewWillAppear
      .do(onNext: { _ in
        NotificationCenter.default.post(name: .tabBarHidden, object: true)
      })
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    rx.viewDidDisappear
      .bind(with: self) { owner, _ in
        NotificationCenter.default.post(name: .tabBarHidden, object: false)
      }
      .disposed(by: disposeBag)

    setLeftItem(.back)
    navigationItem.leftBarButtonItem?.rx.tap
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)

    editButton.rx.tap
      .map { Reactor.Action.didTapEdit }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.pulse(\.$ledger)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, ledger in
        owner.setTitle(
          ledger.fundType == .expense
          ? Const.expenseTitle
          : Const.incomeTitle
        )
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isLoading)
      .compactMap { $0 }
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)

    reactor.pulse(\.$error)
      .compactMap { $0 }
      .bind(with: self) { owner, error in
        owner.coordinator?.present(.alert(
          title: "네트워크 에러",
          subTitle: error.localizedDescription,
          type: .onlyOkButton({})
        ))
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isEdit)
      .withLatestFrom(reactor.pulse(\.$role)) { ($0, $1) }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, info in
        let (isEdit, role) = info
        owner.editButton.setTitle(to: isEdit ? Const.editCompleted : Const.edit)
        owner.setNavigationBarRightButton(isEdit: role == .staff && isEdit)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isValid)
      .distinctUntilChanged()
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isValid in
        owner.navigationItem.rightBarButtonItem?.isEnabled = isValid
        owner.editButton.setState(isValid ? .primary : .disable)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$deleteCompleted)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
  }

  private func setNavigationBarRightButton(isEdit: Bool) {
    isEdit ? setRightItem(.수정완료) : setRightItem(.trash)
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self, onNext: { owner, _ in
        if isEdit {
          owner.reactor?.action.onNext(.didTapEdit)
        } else {
          owner.coordinator?.present(
            .alert(
              title: Const.deleteAlertTitle,
              subTitle: Const.deleteAlertDescription,
              type: .default(
                okAction: { owner.reactor?.action.onNext(.didTapDelete) },
                cancelAction: {}
              )
            )
          )
        }
      })
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var deleteAlertTitle: String { "정말 삭제하시겠습니까?" }
  static var deleteAlertDescription: String { "삭제된 내용은 저장되지 않습니다." }
  static var edit: String { "수정하기" }
  static var editCompleted: String { "수정완료" }
  static var expenseTitle: String { "지출 상세내역" }
  static var incomeTitle: String { "수입 상세내역" }
}
