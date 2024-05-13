import UIKit

import BaseFeature
import DesignSystem
import Utility

import ReactorKit
import PinLayout
import FlexLayout

final class LedgerTabVC: BaseVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?

  private let floatingButton = FloatingButton()
  private let amountGuideLabel: UILabel = {
    let v = UILabel()
    v.text = "이만큼 남았어요"
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._7
    return v
  }()
  private let totalAmountLabel: UILabel = {
    let v = UILabel()
    v.text = "0원"
    v.numberOfLines = 0
    v.font = Fonts.heading._5
    v.textColor = Colors.Gray._10
    return v
  }()
  private let dateBackgroundView: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Gray._1
    v.layer.cornerRadius = 8
    return v
  }()
  private let dateRangeLabel: UILabel = {
    let v = UILabel()
    v.text = "2023년 12월 ~ 2024년 5월"
    v.font = Fonts.body._2
    v.textColor = Colors.Gray._6
    return v
  }()
  private let filterControl: MMSegmentControl = {
    let v = MMSegmentControl(titles: ["전체", "지출", "수입"], type: .capsule)
    v.selectedIndex = 0
    return v
  }()
  private let ledgerList: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 20
    flowLayout.estimatedItemSize.width = UIScreen.main.bounds.width - 40

    let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    v.showsVerticalScrollIndicator = false
    v.register(LedgerCell.self)
    return v
  }()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func setupUI() {
    super.setupUI()
    floatingButton.addWriteAction { [weak self] in
      self?.coordinator?.present(.inputManual)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem().direction(.row).define { flex in
        flex.addItem().justifyContent(.center).define { flex in
          flex.addItem(amountGuideLabel)
          flex.addItem(totalAmountLabel)
            .maxWidth(UIScreen.main.bounds.width - 194)
        }
        flex.addItem().grow(1)
        flex.addItem(UIImageView(image: Images.mongLedger))
      }
      flex.addItem(dateBackgroundView).direction(.row).define { flex in
        flex.addItem(dateRangeLabel).marginRight(8).paddingVertical(10)
        flex.addItem(UIImageView(image: Images.chevronDown)).size(16)
      }.justifyContent(.center).alignItems(.center)
      flex.addItem(filterControl).alignSelf(.start).marginTop(20).marginBottom(16)
      flex.addItem(ledgerList).grow(1)
    }.marginHorizontal(20).marginTop(8)
    
    rootContainer.addSubview(floatingButton)
    floatingButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      floatingButton.bottomAnchor.constraint(equalTo: rootContainer.bottomAnchor, constant: -20),
      floatingButton.rightAnchor.constraint(equalTo: rootContainer.rightAnchor)
    ])
  }
  
  func bind(reactor: LedgerTabReactor) {
    Observable.just(0...11)
      .bind(to: ledgerList.rx.items) { (view, row, element) in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = view.dequeueCell(LedgerCell.self, for: indexPath)
        return cell
      }
      .disposed(by: disposeBag)
    
    dateBackgroundView.rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.datePicker)
      }
      .disposed(by: disposeBag)
  }
}

import RxCocoa

extension Reactive where Base: UIView {
  var tapGesture: ControlEvent<Base> {
    let tapGesture = UITapGestureRecognizer()
    base.addGestureRecognizer(tapGesture)
    let event = tapGesture.rx.event
      .withUnretained(base)
      .flatMap { (base, _) in
        Observable.just(base)
      }
    return ControlEvent(events: event)
  }
}
