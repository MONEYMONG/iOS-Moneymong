import UIKit

import Utility
import DesignSystem

import FlexLayout
import PinLayout
import ReactorKit

final class MMPicker: UIView, View {
  var disposeBag = DisposeBag()
  
  public enum `Type` {
    case year
    case month
  }
  
  public let type: `Type`
  
  private struct ViewSize {
    static let cellSize = CGSize(width: 67, height: 44)
    static let cellSpacing: CGFloat = 20
    static var collectionViewHeight: CGFloat { cellSize.height * 3 + cellSpacing * 2 }
    static var contentInset: UIEdgeInsets {
      UIEdgeInsets(
        top: cellSize.height + cellSpacing,
        left: 0,
        bottom: cellSize.height + cellSpacing,
        right: 0
      )
    }
  }
    
  public let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = ViewSize.cellSpacing
    flowLayout.itemSize = ViewSize.cellSize
    let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    v.showsVerticalScrollIndicator = false
    v.decelerationRate = .fast
    v.contentInset = ViewSize.contentInset
    v.register(DateCell.self)
    return v
  }()
  
  private let pickerTopLine: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Blue._4
    return v
  }()
  
  private let pickerBottomLine: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Blue._4
    return v
  }()

  private let rootContainer = UIView()
  
  init(type: `Type`) {
    self.type = type
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
    
    pickerTopLine.frame = .init(
      x: 0,
      y: (collectionView.bounds.height - ViewSize.cellSize.height) / 2,
      width: ViewSize.cellSize.width,
      height: 2
    )
    
    pickerBottomLine.frame = .init(
      x: 0,
      y: (collectionView.bounds.height + ViewSize.cellSize.height) / 2,
      width: ViewSize.cellSize.width,
      height: 2
    )
  }
  
  private func setupUI() {
    collectionView.delegate = self
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(collectionView)
        .width(ViewSize.cellSize.width)
        .height(ViewSize.collectionViewHeight)
    }
    
    addSubview(pickerTopLine)
    addSubview(pickerBottomLine)
  }
  
  func bind(reactor: DatePickerReactor) {
    reactor.pulse(\.$dateList)
      .map { [weak self] dateList -> [String]? in
        guard let self else { return nil }
        let list = type == .year ? dateList.year : dateList.month
        return list.map {
          return self.type == .year ? "\($0)년" : "\($0)월"
        }
      }
      .compactMap { $0 }
      .bind(to: collectionView.rx.items) { [weak self] view, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = view.dequeueCell(DateCell.self, for: indexPath)
        guard let self else { return cell.configure(date: element) }
        switch type {
        case .year:
          if reactor.currentState.pickerRow?.year == indexPath.row {
            cell.setTitleColor(Colors.Gray._9)
          }
        case .month:
          if reactor.currentState.pickerRow?.month == indexPath.row {
            cell.setTitleColor(Colors.Gray._9)
          }
        }
        return cell.configure(date: element)
      }
      .disposed(by: disposeBag)
    
    
    collectionView.rx.didEndDecelerating
      .bind(with: self) { owner, _ in
        owner.selectDateCell(owner.collectionView)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.didEndScrollingAnimation
      .bind(with: self) { owner, _ in
        owner.selectDateCell(owner.collectionView)
      }
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        owner.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
      }
      .disposed(by: disposeBag)
  }
}

extension MMPicker: UICollectionViewDelegate {
  func scrollViewWillEndDragging(
      _ scrollView: UIScrollView,
      withVelocity velocity: CGPoint,
      targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
      let scrolledOffsetY = targetContentOffset.pointee.y + scrollView.contentInset.top
      let cellHeight = ViewSize.cellSize.height + ViewSize.cellSpacing
      let index = round(scrolledOffsetY / cellHeight)
      targetContentOffset.pointee = CGPoint(
        x: scrollView.contentInset.left,
        y: index * cellHeight - scrollView.contentInset.top
      )
    }
  
  private func selectDateCell(_ collectionView: UICollectionView) {
    let centerPoint = CGPoint(
      x: 0,
      y: collectionView.contentOffset.y + collectionView.bounds.height / 2
    )
    guard let selectedIndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
    
    for i in collectionView.indexPathsForVisibleItems {
      guard let cell = collectionView.cellForItem(at: i) as? DateCell else {
        return
      }
      cell.setTitleColor(
        i == selectedIndexPath ? Colors.Gray._9 : Colors.Gray._300
      )
    }
    reactor?.action.onNext(
      .selectDate(
        row: selectedIndexPath.row,
        component: type == .year ? 0 : 1 /// 0 = yearSlider / 1 = monthSlider
      )
    )
  }
}
