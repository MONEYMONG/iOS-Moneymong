import UIKit

import DesignSystem

import PinLayout
import FlexLayout
import RxSwift

final class DateLabel: UIView {
  enum `Type` {
    case start
    case end
  }
  
  private let rootContainer = UIView()
  private let headerLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Blue._3
    return v
  }()
  private let dateLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.heading._2
    v.textColor = Colors.Blue._4
    return v
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
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
  }

  private func setupView() {
    layer.cornerRadius = 8
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.justifyContent(.center).define { flex in
      flex.addItem(headerLabel).marginBottom(2)
      flex.addItem(dateLabel)
    }
    .paddingHorizontal(12)
    .paddingVertical(10)
    .width((UIScreen.main.bounds.width - 40) * 0.44)
  }
  
  func setHeaderType(type: Type) {
    switch type {
    case .start:
      headerLabel.text = "시작일"
    case .end:
      headerLabel.text = "종료일"
    }
  }
  
  var configure: Binder<DateInfo> {
    return Binder(self) { owner, model in
      if (1...9).contains(model.month) {
        owner.dateLabel.text = "\(model.year)년 0\(model.month)월"
      } else {
        owner.dateLabel.text = "\(model.year)년 \(model.month)월"
      }
    }
  }
  
  var warning: Binder<Bool> {
    return Binder(self) { owner, value in
      if value {
        owner.headerLabel.textColor = Colors.Red._2
        owner.dateLabel.textColor = Colors.Red._3
      } else {
        owner.headerLabel.textColor = Colors.Blue._3
        owner.dateLabel.textColor = Colors.Blue._4
      }
    }
  }
}
