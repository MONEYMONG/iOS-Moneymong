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
  var disposeBag = DisposeBag()
  var coordinator: LedgerCoordinator?
  
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
      flex.addItem(tableView).height(3 * (80) + 12 * 2)
        .margin(16)
      flex.addItem(registerCodeInputButton)
        .marginHorizontal(16)
        .height(56)
        .marginBottom(12)
      flex.addItem(createAgencyButton)
        .height(56)
        .marginHorizontal(16)
        .marginBottom(44)
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
        
        let count = agencies.count
        
        let height = min(CGFloat(count * 80 + (count - 1) * 12), 3 * (80) + 2 * 12)
        owner.tableView.isScrollEnabled = count > 3
        owner.tableView.flex.height(height)
        owner.view.setNeedsLayout()
        
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
