import UIKit

import BaseFeature
import DesignSystem
import Utils

import ReactorKit
import PinLayout
import FlexLayout

enum MyPageSection: Hashable {
  case account
  case setting
}

enum MyPageSectionItem: Hashable {
  case university
  case service
  case privacy
  case withdrawl
  case logout
  case version
}


private typealias DataSource = UITableViewDiffableDataSource<MyPageSection, MyPageSectionItem>
private typealias SnapShot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageSectionItem>

public final class MyPageVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  
  private lazy var tableView: UITableView = {
    let v = UITableView(frame: .zero, style: .insetGrouped)
    v.register(UniversityCell.self)
    v.register(SettingCell.self)
    return v
  }()
  
  private lazy var dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
    switch indexPath.section {
    case 0:
      return tableView
        .dequeueCell(UniversityCell.self, for: indexPath)
        .configure(with: item)
    case 1:
      return tableView
        .dequeueCell(SettingCell.self, for: indexPath)
        .configure(with: item)
    default: fatalError()
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
    // Life Cycle
    rx.viewDidLoad
      .bind(with: self) { owner, _ in
        
      }
      .disposed(by: disposeBag)
    
    // State
    reactor.state.map { (sections: $0.sections, items: $0.items) }
      .asDriver(onErrorRecover: { _ in .empty() })
      .drive(with: self) { (owner, data) in
        var snapshot = SnapShot()
        snapshot.appendSections(data.sections)
        snapshot.appendItems(data.items[0], toSection: data.sections[0])
        snapshot.appendItems(data.items[1], toSection: data.sections[1])
        owner.dataSource.apply(snapshot, animatingDifferences: false)
      }
      .disposed(by: disposeBag)
    
    // Action
  }
}
