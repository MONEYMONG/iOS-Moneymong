import UIKit

import DesignSystem
import BaseFeature
import Utility
import Core
import AgencyFeatureInterface

import ReactorKit
import RxDataSources
import PinLayout
import FlexLayout

public final class AgencyListVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  var coordinator: AgencyCoordinator?
  
  private let emptyView = EmptyAgencyView()
  
  private let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 12    
    let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    v.register(AgencyCell.self)
    v.register(FeedbackCell.self)
    v.backgroundColor = Colors.Gray._1
    return v
  }()
  
  private let searchHeaderView = SearchView()
  
  private let createAgencyButton: UIButton = {
    let v = UIButton()
    v.setBackgroundImage(Images.plusCircleFillRed, for: .normal)
    return v
  }()
  
  public override func setupUI() {
    super.setupUI()
    setTitle("소속찾기")
    collectionView.backgroundView = emptyView
  }
  
  public override func setupConstraints() {
    super.setupConstraints()

    view.addSubview(createAgencyButton)
    
    rootContainer.flex.define { flex in
      flex.addItem(searchHeaderView).height(0)
        .marginLeft(13).marginRight(20)
      flex.addItem(collectionView).grow(1).shrink(1)
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    createAgencyButton.pin.size(70)
      .bottom(view.pin.safeArea + 20)
      .right(view.pin.safeArea + 10)
    
    rootContainer.flex.layout()
  }

  public func bind(reactor: AgencyListReactor) {
    setRightItem(.search)
    // Action Binding
    rx.viewDidLoad
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .observe(on: MainScheduler.instance)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .do(onNext: { [weak self] in
        self?.searchHeaderView.startEditing()
      })
      .map { Reactor.Action.tapSearchBar }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchHeaderView.searchBar.rx.searchButtonClicked
      .observe(on: MainScheduler.instance)
      .do(onNext: { [weak self] in
        self?.searchHeaderView.endEditing()
      })
      .map { Reactor.Action.tapSearchButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchHeaderView.searchBar.rx.text
      .skip(1)
      .compactMap { $0 }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .map { Reactor.Action.searchTextChanged($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchHeaderView.cancelButton.rx.tap
      .observe(on: MainScheduler.instance)
      .map { Reactor.Action.tapCancelButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewWillAppear
      .bind {
        reactor.action.onNext(.requestAgencyList)
        reactor.action.onNext(.requestMyAgency)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(AgencyListReactor.Item.self)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map {
        switch $0 {
        case .feedback:
          return Reactor.Action.feedBack
        case let .agency(agency):
          return Reactor.Action.tap(agency)
        }
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    createAgencyButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .compactMap { reactor.currentState.userInfo?.universityName }
      .map { universityName -> UniversityType in universityName == "정보없음" ? .none : .exists }
      .bind(with: self) { owner, universityType in
        owner.coordinator?.present(.createAgency(universityType))
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.prefetchItems
      .compactMap { $0.last?.row }
      .map { Reactor.Action.didPrefech($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    // Data Binding
    
    reactor.pulse(\.$query)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, query in
        owner.navigationItem.rightBarButtonItem?.setValue(query != nil, forKey: "hidden")
        owner.searchHeaderView.flex.height(query == nil ? 0 : 60)
        owner.searchHeaderView.flex.markDirty()
        UIView.animate(withDuration: 0.2) {
          owner.searchHeaderView.isHidden = query == nil
          owner.rootContainer.flex.layout()
        }
        
        if query == nil {
          owner.searchHeaderView.endEditing()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$items)
      .bind(to: collectionView.rx.items) { view, row, item in
        let indexPath = IndexPath(row: row, section: 0)
        switch item {
        case .feedback:
          return view.dequeueCell(FeedbackCell.self, for: indexPath)
        case let .agency(agency):
          return view.dequeueCell(AgencyCell.self, for: indexPath)
            .configure(with: agency)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$items)
      .map { items in
        items.filter {
          switch $0 {
          case .feedback: false
          case .agency: true
          }
        }
        .isEmpty == false
      }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isHidden in
        owner.emptyView.isHidden = isHidden
        owner.view.backgroundColor = isHidden ? Colors.Gray._1: Colors.White._1
      }
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
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case let .joinAgency(agency):
          owner.coordinator?.present(.joinAgency(id: agency.id, name: agency.name))
        case let .web(url):
          owner.coordinator?.present(.web(url))
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

extension AgencyListVC: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    if indexPath.row == 0 {
      return CGSize(
        width: UIScreen.main.bounds.width - 40,
        height: 68
      )
    } else {
      return CGSize(
        width: UIScreen.main.bounds.width - 40,
        height: 80
      )
    }
  }
}
