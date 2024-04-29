import UIKit

import BaseFeature
import Utility
import DesignSystem

import ReactorKit
import RxDataSources
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
    .bind(with: self) { owner, event in
      let (item, indexPath) = (event.0, event.1)
      owner.tableView.deselectRow(at: indexPath, animated: true)
      
      switch item {
      case .setting(.service):
        owner.coordinator?.presentWeb(urlString: "https://www.notion.so/moneymong/8a382c0e511448838d2d350e16df3a95?pvs=4")
      case .setting(.privacy):
        owner.coordinator?.presentWeb(urlString: "https://www.notion.so/moneymong/7f4338eda8564c1ca4177caecf5aedc8?pvs=4")
      case .setting(.withdrawal):
        owner.coordinator?.pushWithDrawal()
      case .setting(.logout):
        owner.coordinator?.presentAlert(
          title: "정말 로그아웃 하시겠습니까?",
          subTitle: "로그인한 계정이 로그아웃됩니다",
          okAction: {
            reactor.action.onNext(.logout)
          }
        )
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
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind { destination in
        switch destination {
        case .login:
          // TODO: 로그인 화면으로 이동
          break
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$item)
      .observe(on: MainScheduler.instance)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .observe(on: MainScheduler.instance)
      .bind { isLoading in
        // TODO: 로딩인디케이터 돌리기
      }
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
