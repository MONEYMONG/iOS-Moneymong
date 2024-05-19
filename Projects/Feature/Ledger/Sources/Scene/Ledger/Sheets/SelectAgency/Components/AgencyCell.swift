import UIKit

import Utility
import DesignSystem
import NetworkService

final class AgencyCell: UITableViewCell, ReusableView {
  
  private let iconImageView: UIImageView = {
    let v = UIImageView()
    v.image = Images.mongClubFill
    return v
  }()
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._9
    return v
  }()
  
  private let countLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._2
    v.textColor = Colors.Gray._5
    return v
  }()
  
  private let checkMarkImageView = UIImageView(image: Images.check?.withTintColor(Colors.Gray._3))
  
  private let rootContainer = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  private func setupUI() {
    selectionStyle = .none
  }
  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    
    rootContainer.flex.direction(.row).alignItems(.center)
      .padding(16).cornerRadius(16).border(1, Colors.Gray._2).backgroundColor(Colors.White._1)
      .define { flex in
        
        flex.addItem(iconImageView).size(48).marginRight(12)
        
        flex.addItem().define { flex in
          flex.addItem(titleLabel).marginBottom(4)
          flex.addItem(countLabel)
        }
        
        flex.addItem().grow(1)
        flex.addItem(checkMarkImageView).size(24)
    }
      .marginBottom(12)
  }
  
  func configure(with item: Agency, selectedID: Int) -> Self {
    titleLabel.setTextWithLineHeight(text: "\(item.name)", lineHeight: 20)
    countLabel.setTextWithLineHeight(text: "맴버수 \(item.count)", lineHeight: 18)
    
    titleLabel.flex.markDirty()
    countLabel.flex.markDirty()
    
    if item.id == selectedID {
      rootContainer.flex.backgroundColor(Colors.Blue._1).border(1, Colors.Blue._4)
      checkMarkImageView.image = Images.check?.withTintColor(Colors.Blue._4)
      titleLabel.textColor = Colors.Blue._4
    } else {
      rootContainer.flex.backgroundColor(Colors.White._1).border(1, Colors.Gray._2)
      checkMarkImageView.image = Images.check?.withTintColor(Colors.Gray._3)
      titleLabel.textColor = Colors.Gray._9
    }
    
    contentView.setNeedsLayout()
    return self
  }
}
