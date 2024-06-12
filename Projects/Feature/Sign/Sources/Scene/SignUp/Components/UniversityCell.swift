import UIKit

import Utility
import DesignSystem
import NetworkService

final class UniversityCell: UITableViewCell, ReusableView {
  private let schoolImageView: UIImageView = {
    let image = Images.university
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._4
    label.textColor = Colors.Gray._10
    return label
  }()

  private let checkButton: UIButton = {
    let button = UIButton()
    button.setImage(Images.check?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.tintColor = Colors.Gray._3
    button.isUserInteractionEnabled = false
    return button
  }()

  private let rootContainer = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  private func setupUI() {
    contentView.addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex.define { flex in
      flex.addItem().height(20)

      flex.addItem()
        .alignItems(.center)
        .direction(.row).define { flex in
          flex.addItem(schoolImageView).size(22)
          flex.addItem().width(10)
          flex.addItem(nameLabel).grow(1)
          flex.addItem(checkButton).size(24)
        }
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    checkButton.tintColor = selected ? Colors.Blue._4 : Colors.Gray._3
    nameLabel.textColor = selected ? Colors.Blue._4 : Colors.Gray._10
  }

  @discardableResult
  func configure(with item: University) -> Self {
    nameLabel.text = item.schoolName
    return self
  }
}
