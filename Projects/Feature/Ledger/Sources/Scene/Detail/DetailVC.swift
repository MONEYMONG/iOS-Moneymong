import UIKit

import BaseFeature
import ReactorKit
import DesignSystem
import NetworkService

import PinLayout
import FlexLayout

final class DetailVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.bounces = false
    scrollView.keyboardDismissMode = .interactive
    return scrollView
  }()

  private let contentsView = DetailContentsView()

  private let editContentsView = EditContentsView()

  private let editButtonContainer: UIView = {
    let view = UIView()
    view.setShadow(location: .top, color: Colors.Gray._4)
    return view
  }()

  private let editButton = MMButton(title: Const.edit, type: .primary)

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.post(name: .tabBarHidden, object: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.post(name: .tabBarHidden, object: false)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    scrollView.contentSize = reactor?.currentState.isEdit == true
    ? CGSize(
      width: editContentsView.frame.size.width,
      height: editContentsView.frame.size.height + 28
    )
    : CGSize(
      width: contentsView.frame.size.width,
      height: contentsView.frame.size.height + 28
    )

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
      flex.addItem().height(12)

      flex.addItem(scrollView)
        .paddingHorizontal(20)
        .shrink(1)
        .define { flex in
          flex.addItem(contentsView)
          flex.addItem(editContentsView)
        }

      if reactor?.currentState.role == .staff {
        flex.position(.absolute).bottom(0).define { flex in
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
  }

  public func bind(reactor: DetailReactor) {
    rx.viewWillAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
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
        owner.contentsView.configure(ledger: ledger)
        owner.editContentsView.configure(ledger: ledger)
        owner.viewDidLayoutSubviews()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isLoading)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)

    reactor.pulse(\.$isEdit)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isEdit in
        isEdit ? owner.onEditContents() : owner.onDetailContents()
        if reactor.currentState.role == .staff {
          owner.setNavigationBarRightButton(isEdit: isEdit)
        }
        owner.viewDidLayoutSubviews()
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

  private func onDetailContents() {
    editContentsView.isHidden = true
    editContentsView.flex.display(.none)
    contentsView.isHidden = false
    contentsView.flex.display(.flex)
    editButton.setTitle(Const.edit, for: .normal)
    viewDidLayoutSubviews()
    rootContainer.setNeedsLayout()


  }

  private func onEditContents() {
    editContentsView.isHidden = false
    editContentsView.flex.display(.flex)
    contentsView.isHidden = true
    contentsView.flex.display(.none)
    editButton.setTitle(Const.editCompleted, for: .normal)
    rootContainer.setNeedsLayout()
    viewDidLayoutSubviews()

    setRightItem(.수정완료)
  }

  private func setNavigationBarRightButton(isEdit: Bool) {
    if isEdit {
      setRightItem(.수정완료)
      navigationItem.rightBarButtonItem?.rx.tap
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, _ in
          if owner.reactor?.currentState.isEdit == true {
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
    } else {
      setRightItem(.trash)
      navigationItem.rightBarButtonItem?.rx.tap
        .observe(on: MainScheduler.instance)
        .bind(with: self, onNext: { owner, _ in
          if owner.reactor?.currentState.isEdit == true {
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
}

fileprivate enum Const {
  static var deleteAlertTitle: String { "정말 삭제하시겠습니까?" }
  static var deleteAlertDescription: String { "삭제된 내용은 저장되지 않습니다." }
  static var edit: String { "수정하기" }
  static var editCompleted: String { "수정완료" }
  static var expenseTitle: String { "지출 상세내역" }
  static var incomeTitle: String { "수입 상세내역" }
}
