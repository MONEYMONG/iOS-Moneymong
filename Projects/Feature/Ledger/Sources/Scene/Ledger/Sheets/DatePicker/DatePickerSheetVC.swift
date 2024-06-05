import UIKit

import DesignSystem
import BaseFeature

import PinLayout
import FlexLayout
import ReactorKit

final class DatePickerSheetVC: BottomSheetVC, View {
  private let cancelButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.close, for: .normal)
    return v
  }()
  private let startDateLabel: DateLabel = {
    let v = DateLabel()
    v.setHeaderType(type: .start)
    return v
  }()
  private let endDateLabel: DateLabel = {
    let v = DateLabel()
    v.setHeaderType(type: .end)
    return v
  }()
  private let datePicker = DatePicker()
  private let completeButton = MMButton(title: "완료", type: .primary)
  
  var disposeBag = DisposeBag()
  
  override func setupConstraints() {
    super.setupConstraints()
    contentView.flex.define { flex in
      flex.addItem(cancelButton).alignSelf(.end).marginBottom(12)
      flex.addItem().direction(.row).define { flex in
        flex.addItem(startDateLabel)
        flex.addItem().grow(1)
        flex.addItem(endDateLabel)
      }
      flex.addItem().height(1).backgroundColor(Colors.Gray._2).marginVertical(16)
      flex.addItem(datePicker).grow(1).marginBottom(20)
      flex.addItem(completeButton).height(56).marginBottom(12)
    }.padding(20)
  }
  
  func bind(reactor: DatePickerReactor) {
    datePicker.reactor = reactor
    
    rx.viewDidAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    startDateLabel.rx.tapGesture
      .map { _ in Reactor.Action.selectDateLabel(.start) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    endDateLabel.rx.tapGesture
      .map { _ in Reactor.Action.selectDateLabel(.end) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    completeButton.rx.tap
      .map { Reactor.Action.didTapCompleteButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    cancelButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.dismiss()
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      reactor.pulse(\.$selectedDateType),
      reactor.pulse(\.$isWarning)
    )
    .bind(with: self) { owner, value in
      let (pickerState, isWarning) = value
      switch pickerState {
      case .start:
        owner.startDateLabel.backgroundColor = Colors.Blue._1
        owner.endDateLabel.backgroundColor = .clear
      case .end:
        owner.startDateLabel.backgroundColor = .clear
        owner.endDateLabel.backgroundColor = isWarning ? Colors.Red._1 : Colors.Blue._1
      }
    }
    .disposed(by: disposeBag)
    
    reactor.pulse(\.$startDate)
      .bind(to: startDateLabel.date)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$endDate)
      .bind(to: endDateLabel.date)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isWarning)
      .bind(to: endDateLabel.warning)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .bind(with: self) { owner, destination in
        switch destination {
        case .ledger:
          owner.dismiss()
        case .showSnackBar:
          SnackBarManager.show(title: "올바른 범위로 기간을 설정해주세요!")
        }
      }
      .disposed(by: disposeBag)
  }
}
