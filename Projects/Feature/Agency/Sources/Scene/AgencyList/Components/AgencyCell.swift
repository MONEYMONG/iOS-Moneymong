import UIKit

import Utility
import DesignSystem
import NetworkService

import FlexLayout
import PinLayout

final class AgencyCell: UICollectionViewCell, ReusableView {
  
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
  
  private let tagView = TagView()
  
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
      flex.addItem(iconImageView).size(48).marginRight(12)
      
      flex.addItem().define { flex in
        flex.addItem().direction(.row).define { flex in
          flex.addItem(titleLabel).marginRight(6).shrink(1)
          flex.addItem(tagView).shrink(0)
        }.marginBottom(4)
        
        flex.addItem(countLabel)
      }.grow(1).shrink(1)
    }
    .backgroundColor(Colors.White._1).cornerRadius(16)
    .border(1, Colors.Gray._2)
    .padding(16)
  }
  
  func configure(with item: Agency) -> Self {
    titleLabel.text = "\(item.name)"
    countLabel.setTextWithLineHeight(text: "멤버수 \(item.count)", lineHeight: 18)
    tagView.configure(title: "동아리", titleColor: Colors.Blue._4, backgroundColor: Colors.Blue._1)
    
    titleLabel.flex.markDirty()
    countLabel.flex.markDirty()
    tagView.flex.markDirty()
    
    contentView.setNeedsLayout()
    return self
  }
}
