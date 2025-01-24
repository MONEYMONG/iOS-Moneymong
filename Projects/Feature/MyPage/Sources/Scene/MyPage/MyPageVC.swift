import UIKit
import SwiftUI

import BaseFeature
import Utility
import DesignSystem
import Core
import MyPageFeatureInterface

import ReactorKit
import RxDataSources
import FlexLayout

public final class MyPageVC: BaseVC, ReactorKit.View {
  public var disposeBag = DisposeBag()
  
  private let tableView: UITableView = {
    let v = UITableView(frame: .zero, style: .insetGrouped)
    v.separatorInset = .init(top: 0, left: 16, bottom: 0, right: 20)
    v.sectionFooterHeight = 0
    v.register(UniversityCell.self)
    v.register(InquiryCell.self)
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
      
    case .kakaoInquiry:
      return tableView.dequeue(InquiryCell.self, for: indexPath)
        .configure { [weak self] in
          self?.showSafari(urlString: "http://pf.kakao.com/_zDsyG")
        }
      
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
        owner.showSafari(urlString: "https://www.notion.so/moneymong/8a382c0e511448838d2d350e16df3a95?pvs=4")
      case .setting(.privacy):
        owner.showSafari(urlString: "https://moneymong.notion.site/6e55b920fa3c47f6aeea84b4f1008563?pvs=4")
      case .setting(.withdrawal):
        let withdrawalVC = DIContainer.shared.resolve(type: MyPageFactoryInterface.self).makeWithdrawalVC()
        owner.navigationController?.pushViewController(withdrawalVC, animated: true)
      case .setting(.logout):
        owner.showAlert(
          title: "정말 로그아웃 하시겠습니까?",
          subTitle: "로그인한 계정이 로그아웃됩니다",
          type: .default(okAction: { reactor.action.onNext(.logout) })
        )
      default: break
      }
    }
    .disposed(by: disposeBag)
    
    // Data Binding
    reactor.pulse(\.$isLoading)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, error in
        owner.showAlert(
          title: "네트워크 에러",
          subTitle: error.localizedDescription,
          type: .onlyOkButton()
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .login:
          NotificationCenter.default.post(name: .moveLogin, object: nil)
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
    default: return nil
    }
  }
}
