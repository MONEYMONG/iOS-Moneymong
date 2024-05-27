import UIKit
import SwiftUI

import BaseFeature
import Utility
import DesignSystem

import ReactorKit
import RxDataSources
import FlexLayout

public final class MyPageVC: BaseVC, ReactorKit.View {
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
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  public func bind(reactor: MyPageReactor) {
    // Action Binding
    rx.viewDidLoad
      .map { Reactor.Action.onappear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    Observable.zip(
      tableView.rx.modelSelected(MyPageSectionItemModel.Item.self),
      tableView.rx.itemSelected
    )
    .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
    .bind(with: self) { owner, event in
      let (item, indexPath) = (event.0, event.1)
      owner.tableView.deselectRow(at: indexPath, animated: true)
      
      switch item {
      case .setting(.service):
        owner.coordinator?.present(.web(urlString: "https://www.notion.so/moneymong/8a382c0e511448838d2d350e16df3a95?pvs=4"))
      case .setting(.privacy):
        owner.coordinator?.present(.web(urlString: "https://www.notion.so/moneymong/7f4338eda8564c1ca4177caecf5aedc8?pvs=4"))
      case .setting(.withdrawal):
        owner.coordinator?.present(.withrawal)
      case .setting(.logout):
        owner.coordinator?.present(.alert(
          title: "정말 로그아웃 하시겠습니까?",
          subTitle: "로그인한 계정이 로그아웃됩니다",
          okAction: { reactor.action.onNext(.logout) })
        )
      case .setting(.versionInfo):
        #if DEBUG
        owner.coordinator?.present(.debug)
        #endif
      default: break
      }
    }
    .disposed(by: disposeBag)
    
    // Data Binding
    reactor.pulse(\.$showToast)
      .filter { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, event in
        SnackBarManager.show(title: "다시 시도해 주세요")
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .bind(with: self) { owner, error in
        
        owner.coordinator?.present(.alert(
          title: "네트워크 에러",
          subTitle: error.localizedDescription,
          okAction: { })
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .login:
          owner.coordinator?.goLogin()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$item)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

extension MyPageVC: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    switch section {
    case 0:
      guard let sectionModel = dataSource.sectionModels.first?.model else { return nil }
      return tableView.dequeueHeaderFooter(UniversityHeader.self)
        .configure(with: sectionModel)
      
    case 1:
      return tableView.dequeueHeaderFooter(SettingHeader.self)
      
    default: return nil
    }
  }
}
