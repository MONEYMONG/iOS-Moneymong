import UIKit

import BaseFeature
import NetworkService
import Utility
import DesignSystem

import ReactorKit
import RxDataSources
import PinLayout
import FlexLayout

public final class MyPageVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  
  private let tableView: UITableView = {
    let v = UITableView(frame: .zero, style: .insetGrouped)
    v.register(UniversityCell.self)
    v.register(SettingCell.self)
    v.registerHeaderFooter(SettingHeader.self)
    v.registerHeaderFooter(UniversityHeader.self)
    return v
  }()
  
  private lazy var dataSource = RxTableViewSectionedReloadDataSource<MyPageSectionItemModel.Model> { dataSource, tableView, indexPath, item in
    
    switch item {
    case let .university(model):
      return tableView.dequeue(UniversityCell.self, for: indexPath)
        .configure(with: .university(model))
      
    case let .setting(model):
      return tableView.dequeue(SettingCell.self, for: indexPath)
        .configure(with: .setting(model))
    }
  }
  
  
  public override func setupUI() {
    super.setupUI()
    
    setTitle("마이몽")
  }
  
  public override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.define { flex in
      flex.addItem(tableView).width(100%).height(100%)
    }
  }
  
  public func bind(reactor: MyPageReactor) {
    // Action Binding
    rx.viewDidLoad
      .map { Reactor.Action.onappear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    // Data Binding
    reactor.state.map(\.showToast)
      .filter { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, event in
        SnackBarManager.show(title: "다시 시도해 주세요")
      }
      .disposed(by: disposeBag)
    
    Observable.zip(
      tableView.rx.modelSelected(MyPageSectionItemModel.Item.self),
      tableView.rx.itemSelected
    )
    .observe(on: MainScheduler.instance)
    .bind(with: self) { owner, event in
      let (item, indexPath) = (event.0, event.1)
      owner.tableView.deselectRow(at: indexPath, animated: true)
      
      // TODO: Coordinator!
      switch item {
      case .setting(.service): break
      case .setting(.privacy): break
      case .setting(.withdrawal): break
      case .setting(.logout): break
      default: break
      }
    }
    .disposed(by: disposeBag)
    
    reactor.state.map(\.item)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    reactor.state.map(\.isLoading)
      .bind { value in
        // TODO: 인디케이터 보여주기 (전역적으로 구현하자)
      }
      .disposed(by: disposeBag)
  }
}

extension MyPageVC: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch section {
    case 0:
      return tableView.dequeueHeaderFooter(UniversityHeader.self)
        
    case 1:
      return tableView.dequeueHeaderFooter(SettingHeader.self)
    default: return nil
    }
  }
}
