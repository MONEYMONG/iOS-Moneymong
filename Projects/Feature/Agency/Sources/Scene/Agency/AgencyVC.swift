import UIKit

import DesignSystem
import BaseFeature
import Utility

import ReactorKit
import RxDataSources
import PinLayout
import FlexLayout

public final class AgencyVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?
  
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
  
  private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<AgencySectionModel> { dataSource, collectionView, indexPath, item in
    return collectionView.dequeueCell(AgencyCell.self, for: indexPath)
      .configure(with: item)
  }
  
  public override func setupUI() {
    super.setupUI()
    setTitle("소속찾기")
  }
  
  public override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.define { flex in
      flex.addItem(collectionView).width(100%).height(100%)
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  public func bind(reactor: AgencyReactor) {
    // Action Binding
    rx.viewWillAppear
      .map { _ in Reactor.Action.requestAgencyList }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // Data Binding
    reactor.pulse(\.$items)
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
