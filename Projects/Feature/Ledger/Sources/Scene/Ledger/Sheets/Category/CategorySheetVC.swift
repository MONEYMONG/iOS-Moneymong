import UIKit

import DesignSystem
import BaseFeature

import PinLayout
import FlexLayout
import ReactorKit

final class CategorySheetVC: BottomSheetVC, View {
  private let cancelButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.close, for: .normal)
    return v
  }()
  
  private let createButton: UIButton = {
    let v = UIButton()
    let attributedString = NSAttributedString(
      string: "추가",
      attributes: [
        .font: Fonts.body._3,
        .foregroundColor: Colors.Blue._4
      ]
    )
    v.setAttributedTitle(attributedString, for: .normal)
    return v
  }()
  
  private let chipListView: ChipListView = {
    let v = ChipListView()
    v.mode = .edit
    return v
  }()
  
  private let scrollView: ChipScrollView = {
    let v = ChipScrollView()
    v.alwaysBounceVertical = true
    v.canCancelContentTouches = true
    v.showsVerticalScrollIndicator = false
    v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    return v
  }()
  
  private let contentContainer = UIView()
  
  var disposeBag = DisposeBag()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.contentSize = contentContainer.frame.size
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    contentView.flex.define { flex in
      flex.addItem(cancelButton).alignSelf(.end).marginBottom(8)
      flex.addItem().direction(.row).define { flex in
        flex.addItem(UILabel().text("카테고리", font: Fonts.heading._4, color: .black))
        flex.addItem().grow(1)
        flex.addItem(createButton)
      }.marginBottom(4)
      flex.addItem(UILabel().text("원하는 카테고리를 마음대로 만들 수 있어요", font: Fonts.body._2, color: Colors.Gray._5)).marginBottom(16)
      flex.addItem(scrollView).shrink(1).define { flex in
        flex.addItem(contentContainer).define { flex in
          flex.addItem(chipListView)
        }
      }
    }
    .paddingHorizontal(16)
    .paddingVertical(20)
    
    contentHeight = 530
  }
  
  func bind(reactor: CategoryReactor) {
    bindAction(reactor)
    bindState(reactor)
  }
  
  private func bindAction(_ reactor: CategoryReactor) {
    cancelButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.dismiss()
      }
      .disposed(by: disposeBag)
    
    chipListView.chipTapAction = { _, index in
      reactor.action.onNext(.didTapDeleteButton(index))
    }
    
    createButton.rx.tap
      .map { Reactor.Action.didTapCreateButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewWillDisappear
      .map { Reactor.Action.onDisappear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(_ reactor: CategoryReactor) {
    reactor.pulse(\.$categories)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, categories in
        owner.chipListView.setupChips(with: categories.map(\.name))
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .bind(with: self) { owner, destination in
        switch destination {
        case let .createCategory(agencyId):
          let createCategoryVC = CreateCategoryVC()
          createCategoryVC.reactor = CreateCategoryReactor(agencyId: agencyId)
          owner.sheetNavigation.pushViewController(createCategoryVC, animated: true)
        }
      }
      .disposed(by: disposeBag)
  }
}

private class ChipScrollView: UIScrollView {
  override func touchesShouldCancel(in view: UIView) -> Bool {
    if view is UIButton {
      return true
    }
    return super.touchesShouldCancel(in: view)
  }
}
