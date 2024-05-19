import UIKit

import DesignSystem
import NetworkService
import Utility

import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

final class SelectAgencySheetVC: BottomSheetVC, View {
  
  var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?
  
  private let tableView: UITableView = {
    let v = UITableView()
    v.register(AgencyCell.self)
    v.showsVerticalScrollIndicator = false
    v.separatorStyle = .none
    return v
  }()
  
  override func setupConstraints() {
    super.setupConstraints()
    
    contentView.flex.define { flex in
      flex.addItem(tableView).height(80 * (80 + 12))
        .margin(20, 20, 0, 20)
    }
  }
  
  func bind(reactor: SelectAgencySheetReactor) {
    rx.viewWillAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Agency.self)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
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
          .dequeue(AgencyCell.self, for: IndexPath(index: index))
          .configure(with: item, selectedID: reactor.currentState.selectedAgencyID)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$agency)
      .skip(1)
      .map { min(CGFloat($0.count * (80 + 12)), 3 * (80 + 12)) }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, height in
        owner.tableView.flex.height(height)
        owner.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .bind(with: self) { owner, error in
        owner.coordinator?.present(.alert(
          title: "네트워크 에러",
          subTitle: error?.localizedDescription,
          type: .onlyOkButton { }
        ))
      }
      .disposed(by: disposeBag)
  }
}
