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
  private let totalBalanceLabel: UILabel = {
    let v = UILabel()
    v.numberOfLines = 0
    v.font = Fonts.heading._5
    v.textColor = Colors.Gray._10
    return v
  }()
  private let dateRangeView: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Gray._1
    v.layer.cornerRadius = 8
    return v
  }()
  private let dateRangeLabel: UILabel = {
    let v = UILabel()
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
  private let emptyView = LedgerListEmptyView()
  
  override func setupUI() {
    super.setupUI()
    floatingButton.addWriteAction { [weak self] in
      self?.coordinator?.present(.inputManual)
    }
    ledgerList.backgroundView = emptyView
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem().direction(.row).define { flex in
        flex.addItem().justifyContent(.center).define { flex in
          flex.addItem(amountGuideLabel)
          flex.addItem(totalBalanceLabel)
            .maxWidth(UIScreen.main.bounds.width - 194)
        }
        flex.addItem().grow(1)
        flex.addItem(UIImageView(image: Images.mongLedger))
      }
      flex.addItem(dateRangeView).direction(.row).define { flex in
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
    dateRangeView.rx.tapGesture
      .map { _ in Reactor.Action.didTapDateRangeView }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$totalBalance)
      .distinctUntilChanged()
      .map { "\($0)원" }
      .observe(on: MainScheduler.instance)
      .bind(with: self, onNext: { owner, value in
        owner.totalBalanceLabel.text = value
        owner.totalBalanceLabel.flex.markDirty()
        owner.view.setNeedsLayout()
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$ledgers)
      .bind(to: ledgerList.rx.items) { view, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = view.dequeueCell(LedgerCell.self, for: indexPath)
        return cell.configure(with: element)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$ledgers)
      .observe(on: MainScheduler.instance)
      .map { !$0.isEmpty }
      .bind(to: emptyView.rx.isHidden)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$dateRange)
      .bind(with: self) { owner, dateRange in
        owner.dateRangeLabel.text = "\(dateRange.start.year)년 \(dateRange.start.month)월 ~ \(dateRange.end.year)년 \(dateRange.end.month)월"
        owner.dateRangeLabel.flex.markDirty()
        owner.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .bind(with: self) { owner, destination in
        switch destination {
        case let .datePicker(start, end):
          owner.coordinator?.present(.datePicker(start: start, end: end))
        }
      }
      .disposed(by: disposeBag)
  }
}