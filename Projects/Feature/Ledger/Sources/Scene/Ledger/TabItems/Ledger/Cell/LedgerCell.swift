import UIKit

import Utility
import DesignSystem
import NetworkService

final class LedgerCell: UICollectionViewCell, ReusableView {
  private let numberLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Blue._4
    v.text = "00"
    return v
  }()

  private let titleLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._10
    v.text = "테스트"
    return v
  }()
  
  private let dateLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._1
    v.textColor = Colors.Gray._4
    v.text = "2023.11.16 15:36:11"
    return v
  }()
  
  private let amountLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._10
    v.text = "+1,500,000"
    return v
  }()
  
  private let balanceLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._2
    v.textColor = Colors.Gray._6
    v.text = "잔액 1,500,000원"
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
      }.marginLeft(10)
      flex.addItem().grow(1)
      flex.addItem().define { flex in
        flex.addItem(amountLabel).marginBottom(2).alignSelf(.end)
        flex.addItem(balanceLabel)
      }
    }
  }

  func configure(with item: Any) -> Self {
    contentView.setNeedsLayout()
    return self
  }
}
