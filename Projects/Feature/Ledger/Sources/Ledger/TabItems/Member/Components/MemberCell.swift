import UIKit

import NetworkService
import DesignSystem
import Utility

import FlexLayout
import PinLayout

final class MemberCell: UITableViewCell, ReusableView {
  
  private let rootContainer = UIView()
  
  private let iconImageView = UIImageView(image: Images.mong)
  
  private let nameLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._10
    return v
  }()
  
  private let roleView = TagView()
  
  private let moreButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.more?.withTintColor(Colors.Gray._5), for: .normal)
    return v
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.pin.layout()
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    rootContainer.flex.paddingVertical(5).alignItems(.center).direction(.row).define { flex in
      flex.addItem(iconImageView).size(44).marginRight(8)
      flex.addItem(nameLabel).marginRight(6)
      flex.addItem(roleView)
      flex.addItem().grow(1)
      flex.addItem(moreButton).size(24)
    }
  }
  
  func configure(member: Member, role: Member.Role) {
    nameLabel.setTextWithLineHeight(text: member.nickname, lineHeight: 24)
    moreButton.flex.display(role == .staff ? .flex : .none)
    
    switch member.role {
    case .member:
      roleView.configure(title: "일반맴버", titleColor: Colors.White._1, backgroundColor: Colors.Mint._3)
    case .staff:
      roleView.configure(title: "운영진", titleColor: Colors.White._1, backgroundColor: Colors.Blue._4)
    }

    nameLabel.flex.markDirty()
    roleView.flex.markDirty()
    setNeedsLayout()
  }
}
