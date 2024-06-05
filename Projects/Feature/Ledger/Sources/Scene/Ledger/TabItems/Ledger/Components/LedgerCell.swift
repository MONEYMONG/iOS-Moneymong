import UIKit

import Utility
import DesignSystem
import NetworkService

import FlexLayout
import PinLayout

final class LedgerCell: UICollectionViewCell, ReusableView {
  private let numberLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Blue._4
    return v
  }()

  private let titleLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._10
    return v
  }()
  
  private let dateLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._1
    v.textColor = Colors.Gray._4
    return v
  }()
  
  private let amountLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    return v
  }()
  
  private let balanceLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._2
    v.textColor = Colors.Gray._6
    return v
  }()

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
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  private func setupConstraints() {
    contentView.addSubview(rootContainer)

    rootContainer.flex.direction(.row).define { flex in
      flex.addItem(UIImageView(image: Images.shape)).define { flex in
        flex.addItem(numberLabel)
      }
      .justifyContent(.center).alignItems(.center).size(38)
      flex.addItem().define { flex in
        flex.addItem(titleLabel).marginBottom(2)
        flex.addItem(dateLabel)
      }.marginLeft(10).maxWidth(55%)
      flex.addItem().grow(1)
      flex.addItem().define { flex in
        flex.addItem(amountLabel).marginBottom(2)
        flex.addItem(balanceLabel)
      }.alignItems(.end)
    }
  }

  func configure(with item: Ledger, formatter: ContentFormatter) -> Self {
    numberLabel.text = "\(item.order)"
    titleLabel.text = item.storeInfo
    let balance = formatter.convertToAmount(with: item.balance) ?? "0"
    balanceLabel.text = "잔액 \(balance)원"
    let (date, time) = formatter.splitToDateTime(with: item.paymentDate)
    dateLabel.text = date + " " + time
    let amount = formatter.convertToAmount(with: String(item.amount)) ?? "0"
    switch item.fundType {
    case .income:
      amountLabel.textColor = Colors.Gray._10
      amountLabel.text = "+\(amount)원"
    case .expense:
      amountLabel.textColor = Colors.Red._3
      amountLabel.text = "-\(amount)원"
    }
    
    numberLabel.flex.markDirty()
    titleLabel.flex.markDirty()
    balanceLabel.flex.markDirty()
    amountLabel.flex.markDirty()
    contentView.setNeedsLayout()
    return self
  }
}
