import UIKit

import DesignSystem
import BaseFeature
import Utility
import NetworkService

import ReactorKit
import RxDataSources
import PinLayout
import FlexLayout

public final class AgencyListVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?
  
  private let emptyView = EmptyAgencyView()
  
  private let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumInteritemSpacing = 10
    flowLayout.estimatedItemSize.width = UIScreen.main.bounds.width - 40
    
    let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    v.register(AgencyCell.self)
    v.backgroundColor = Colors.Gray._1
    return v
  }()
  
  private let createAgencyButton: UIButton = {
    let v = UIButton()
    v.setBackgroundImage(Images.plusCircleFillRed, for: .normal)
    return v
  }()
  
  private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<AgencySectionModel> { dataSource, collectionView, indexPath, item in
    return collectionView.dequeueCell(AgencyCell.self, for: indexPath)
      .configure(with: item)
  }
  
  public override func setupUI() {
    super.setupUI()
    setTitle("소속찾기")
    view.backgroundColor = Colors.Gray._1
    collectionView.backgroundView = emptyView
  }
  
  public override func setupConstraints() {
    super.setupConstraints()

    view.addSubview(collectionView)
    view.addSubview(createAgencyButton)
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collectionView.pin.all(view.pin.safeArea)
    createAgencyButton.pin.size(70).bottom(view.pin.safeArea + 10).right(view.pin.safeArea + 10)
  }

  public func bind(reactor: AgencyListReactor) {
    // Action Binding
    rx.viewWillAppear
      .bind {
        reactor.action.onNext(.requestAgencyList)
        reactor.action.onNext(.requestMyAgency)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(Agency.self)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.tap($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    createAgencyButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.createAgency)
      }
      .disposed(by: disposeBag)
    
    // Data Binding
    reactor.pulse(\.$items)
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$items)
      .map { $0.isEmpty == false }
      .bind(to: emptyView.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .observe(on: MainScheduler.instance)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, error in
        owner.coordinator?.present(.alert(title: "네트워크에러", subTitle: nil, okAction: { }))
        print(error)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case let .joinAgency(agency):
          owner.coordinator?.present(.joinAgency(id: agency.id, name: agency.name))
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$alert)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, alert in
        owner.coordinator?.present(.alert(
          title: alert.title,
          subTitle: alert.subTitle,
          okAction: {}
        ))
      }
      .disposed(by: disposeBag)
  }
}
