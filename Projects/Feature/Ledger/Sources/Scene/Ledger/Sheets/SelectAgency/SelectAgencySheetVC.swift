import UIKit

import BaseDomain
import DesignSystem
import Utility

import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

final class SelectAgencySheetVC: BottomSheetVC, View {
  private struct Constant {
    static let buttonHeight: CGFloat = 56
    static let buttonSpacing: CGFloat = 12
    static let bottomSpacing: CGFloat = 34
    static let topSpacing: CGFloat = 20
    static let horizontalMargin: CGFloat = 16
    static let cellHeight: CGFloat = 72
    static let cellSpacing: CGFloat = 12
  }
  
  var disposeBag = DisposeBag()
  var coordinator: LedgerCoordinator?
  private var componentHeight: CGFloat = 0
  
  private let tableView: UITableView = {
    let v = UITableView()
    v.register(AgencyCell.self)
    v.showsVerticalScrollIndicator = false
    v.separatorStyle = .none
    return v
  }()
  
  private let registerCodeInputButton: MMButton = MMButton(title: "초대 코드 입력하기", image: Images.pencil, type: .tertiary)
  private let createAgencyButton: MMButton = MMButton(title: "새로운 장부 만들기", image: Images.plusCircleLineWhite, type: .primary)
  
  override func setupConstraints() {
    super.setupConstraints()
    
    contentView.flex.define { flex in
      flex.addItem(tableView).height(3 * (Constant.cellHeight) + Constant.cellSpacing * 3)
        .marginTop(Constant.topSpacing)
        .marginHorizontal(Constant.horizontalMargin)
      flex.addItem(registerCodeInputButton)
        .marginHorizontal(Constant.horizontalMargin)
        .height(Constant.buttonHeight)
        .marginVertical(Constant.buttonSpacing)
      flex.addItem(createAgencyButton)
        .height(Constant.buttonHeight)
        .marginHorizontal(Constant.horizontalMargin)
        .marginBottom(Constant.buttonSpacing + Constant.bottomSpacing)
      
      componentHeight = Constant.topSpacing + Constant.buttonHeight * 2 + Constant.buttonSpacing * 3 + Constant.bottomSpacing // (버튼 + 마진) 높이
      contentHeight = componentHeight + 3 * (Constant.cellHeight) + Constant.cellSpacing * 2 // 소속 리스트 높이
    }
  }
  
  func bind(reactor: SelectAgencySheetReactor) {
    rx.viewWillAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Agency.self)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .do(afterNext: { [weak self] _ in
        self?.dismiss()
      })
      .map { Reactor.Action.tapCell($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    createAgencyButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: false)
        owner.coordinator?.createAgency()
      }
      .disposed(by: disposeBag)
    
    registerCodeInputButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: false)
        owner.coordinator?.joinAgency()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$selectedAgencyID)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.tableView.reloadData()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$agency)
      .bind(to: tableView.rx.items) { tableview, index, item in
        return tableview
          .dequeue(AgencyCell.self, for: IndexPath(item: index, section: 0))
          .configure(with: item, selectedID: reactor.currentState.selectedAgencyID)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$agency)
      .skip(1)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, agencies in
        let count = CGFloat(agencies.count)
        let height = min(
          count * 72 + count * 12,
          3 * (72) + 3 * 12
        )
        
        owner.tableView.isScrollEnabled = count > 3
        owner.contentHeight = owner.componentHeight + height
        owner.update {
          owner.tableView.flex.height(height).markDirty()
        }
        
        if let index = agencies.firstIndex(where: { $0.id == reactor.currentState.selectedAgencyID }) {
          owner.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, error in
        AlertsManager.show(title: "네트워크 에러", subTitle: error.localizedDescription, type: .onlyOkButton({ }))
      }
      .disposed(by: disposeBag)
  }
}

