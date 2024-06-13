import UIKit

import DesignSystem
import Utility

import FlexLayout
import PinLayout
import ReactorKit

final class MMDatePicker: UIView, View {
  var disposeBag = DisposeBag()
  
  private let yearPicker = MMPicker(type: .year)
  private let monthPicker = MMPicker(type: .month)  
  private let rootContainer = UIView()
  
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
    let sideInset = rootContainer.bounds.width / 2 - 87
    yearPicker.flex.width(rootContainer.bounds.width / 2 - 20).markDirty()
    monthPicker.flex.width(rootContainer.bounds.width / 2 - 20).markDirty()
    yearPicker.collectionView.contentInset.left = sideInset
    monthPicker.collectionView.contentInset.right = sideInset
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.direction(.row).define { flex in
      flex.addItem(yearPicker).marginRight(40)
      flex.addItem(monthPicker)
    }
  }
  
  func bind(reactor: DatePickerReactor) {    
    yearPicker.reactor = reactor
    monthPicker.reactor = reactor
    reactor.pulse(\.$pickerRow)
      .compactMap { $0 }
      .bind(with: self) { owner, value in
        owner.yearPicker.collectionView.scrollToItem(
          at: IndexPath(row: value.year, section: 0), at: .top, animated: false
        )
        owner.monthPicker.collectionView.scrollToItem(
          at: IndexPath(row: value.month, section: 0), at: .top, animated: false
        )
        owner.yearPicker.collectionView.reloadData()
        owner.monthPicker.collectionView.reloadData()
      }
      .disposed(by: disposeBag)
  }
}

