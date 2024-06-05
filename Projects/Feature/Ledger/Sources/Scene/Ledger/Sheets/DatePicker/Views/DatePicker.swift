import UIKit

import DesignSystem

import FlexLayout
import PinLayout
import ReactorKit

final class DatePicker: UIView, View {
  var disposeBag = DisposeBag()
  
  private struct ViewSize {
    static let cellSize = CGSize(width: 67, height: 44)
    static let cellSpacing: CGFloat = 20
    static var collectionViewHeight: CGFloat { cellSize.height * 3 + cellSpacing * 2
    }
    static var contentInset: UIEdgeInsets {
      UIEdgeInsets(top: cellSize.height + cellSpacing, left: 0, bottom: cellSize.height + cellSpacing, right: 0)
    }
  }
  
  private let yearSlider: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = ViewSize.cellSpacing
    flowLayout.itemSize = ViewSize.cellSize
    let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    v.showsVerticalScrollIndicator = false
    v.decelerationRate = .fast
    v.contentInset = ViewSize.contentInset
    v.tag = 0
    v.register(DateCell.self)
    return v
  }()
  
  private let yearSliderTopLine: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Blue._4
    return v
  }()
  
  private let yearSliderBottomLine: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Blue._4
    return v
  }()
  
  private let monthSlider: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = ViewSize.cellSpacing
    flowLayout.itemSize = ViewSize.cellSize
    let v = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    v.showsVerticalScrollIndicator = false
    v.decelerationRate = .fast
    v.contentInset = ViewSize.contentInset
    v.register(DateCell.self)
    v.tag = 1
    return v
  }()
  
  private let monthSliderTopLine: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Blue._4
    return v
  }()
  
  private let monthSliderBottomLine: UIView = {
    let v = UIView()
    v.backgroundColor = Colors.Blue._4
    return v
  }()
  
  private let rootContainer = UIView()
  private let sliderContainer = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
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
    
    yearSliderTopLine.frame = .init(
      x: sliderContainer.frame.origin.x,
      y: (yearSlider.bounds.height - ViewSize.cellSize.height) / 2,
      width: ViewSize.cellSize.width,
      height: 2
    )
    
    yearSliderBottomLine.frame = .init(
      x: sliderContainer.frame.origin.x,
      y: (yearSlider.bounds.height + ViewSize.cellSize.height) / 2,
      width: ViewSize.cellSize.width,
      height: 2
    )
    
    monthSliderTopLine.frame = .init(
      x: sliderContainer.frame.origin.x + 40 + ViewSize.cellSize.width,
      y: (monthSlider.bounds.height - ViewSize.cellSize.height) / 2,
      width: ViewSize.cellSize.width,
      height: 2
    )
    
    monthSliderBottomLine.frame = .init(
      x: sliderContainer.frame.origin.x + 40 + ViewSize.cellSize.width,
      y: (monthSlider.bounds.height + ViewSize.cellSize.height) / 2,
      width: ViewSize.cellSize.width,
      height: 2
    )
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.define { flex in
      flex.addItem(sliderContainer).direction(.row).define { flex in
        flex.addItem(yearSlider).width(ViewSize.cellSize.width).marginRight(40)
        flex.addItem(monthSlider).width(ViewSize.cellSize.width)
      }
      .height(ViewSize.collectionViewHeight)
    }
    .alignItems(.center).justifyContent(.center)
    addSubview(yearSliderTopLine)
    addSubview(yearSliderBottomLine)
    addSubview(monthSliderTopLine)
    addSubview(monthSliderBottomLine)
  }
  
  func bind(reactor: DatePickerReactor) {
    reactor.pulse(\.$yearList)
      .map { items in
        items.map { "\($0)년" }
      }
      .bind(to: yearSlider.rx.items) { view, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = view.dequeueCell(DateCell.self, for: indexPath)
        if reactor.currentState.pickerRow?.year == indexPath.row {
          cell.setTitleColor(Colors.Gray._9)
        }
        return cell.configure(date: element)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$monthList)
      .map { items in
        items.map { "\($0)월" }
      }
      .bind(to: monthSlider.rx.items) { view, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = view.dequeueCell(DateCell.self, for: indexPath)
        if reactor.currentState.pickerRow?.month == indexPath.row {
          cell.setTitleColor(Colors.Gray._9)
        }
        return cell.configure(date: element)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$pickerRow)
      .compactMap { $0 }
      .bind(with: self) { owner, value in
        owner.yearSlider.scrollToItem(
          at: IndexPath(row: value.year, section: 0), at: .top, animated: false
        )
        owner.monthSlider.scrollToItem(
          at: IndexPath(row: value.month, section: 0), at: .top, animated: false
        )
        owner.yearSlider.reloadData()
        owner.monthSlider.reloadData()
      }
      .disposed(by: disposeBag)
    
    monthSlider.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    monthSlider.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        owner.monthSlider.scrollToItem(at: indexPath, at: .top, animated: true)
      }
      .disposed(by: disposeBag)
    
    yearSlider.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    yearSlider.rx.itemSelected
      .bind(with: self) { owner, indexPath in
        owner.yearSlider.scrollToItem(at: indexPath, at: .top, animated: true)
      }
      .disposed(by: disposeBag)
  }
}

extension DatePicker: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
  /// Slider의 스크롤이 끝났을 때 호출
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    switch scrollView.tag {
    case 0:
      selectDateCell(yearSlider)
    case 1:
      selectDateCell(monthSlider)
    default: break
    }
  }
  
  /// CollectionView 페이징
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
  
  func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else { return }
    cell.setTitleColor(Colors.Gray._300)
  }
  
  /// Slider의 cell을 클릭했을 때 `scrollToItem` 에니메이션이 끝나고 호출
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    scrollViewDidEndDecelerating(scrollView)
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
        component: collectionView.tag /// 0 = yearSlider / 1 = monthSlider
      )
    )
  }
}

