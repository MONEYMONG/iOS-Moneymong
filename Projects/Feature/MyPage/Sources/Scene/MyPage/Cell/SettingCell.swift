import UIKit

import Utility
import DesignSystem

final class SettingCell: UITableViewCell, ReusableView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    v.font = Fonts.body._4
    return v
  }()
  
  private let iconImageView: UIImageView = {
    let v = UIImageView()
    v.contentMode = .scaleAspectFit
    v.tintColor = Colors.Gray._7
    return v
  }()
  
  private let disclosureIndicator: UIImageView = {
    let v = UIImageView()
    v.image = Images.chevronRight?.withRenderingMode(.alwaysTemplate)
    v.contentMode = .scaleAspectFit
    v.tintColor = Colors.Gray._7
    return v
  }()
  
  private let versionLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "1.0.0", lineHeight: 24)
    v.textColor = Colors.Blue._4
    v.font = Fonts.body._4
    return v
  }()
  
  private let rootContainer = UIView()
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(rootContainer)
  }
  
  private func setupConstraints() {
    rootContainer.flex.direction(.row).alignItems(.center).padding(16).define { flex in
      flex.addItem(iconImageView).size(20).marginRight(8)
      flex.addItem(titleLabel).grow(1)
      flex.addItem(disclosureIndicator).size(24)
      flex.addItem(versionLabel)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  @discardableResult
  func configure(with item: MyPageSectionItemModel.Item) -> Self {
    guard case let .setting(model) = item else { return self }
    
    iconImageView.image = model.icon?.withRenderingMode(.alwaysTemplate)
    titleLabel.setTextWithLineHeight(text: model.title, lineHeight: 24)
    
    switch model.accessoryType {
    case .disclosureIndicator:
      disclosureIndicator.flex.isIncludedInLayout(true).markDirty()
      disclosureIndicator.isHidden = false
      versionLabel.flex.isIncludedInLayout(false).markDirty()
      versionLabel.isHidden = true
    case .version:
      disclosureIndicator.flex.isIncludedInLayout(false).markDirty()
      disclosureIndicator.isHidden = true
      versionLabel.flex.isIncludedInLayout(true).markDirty()
      versionLabel.isHidden = false
    case .no:
      disclosureIndicator.flex.isIncludedInLayout(false).markDirty()
      disclosureIndicator.isHidden = true
      versionLabel.flex.isIncludedInLayout(false).markDirty()
      versionLabel.isHidden = true
    }
    
    contentView.setNeedsLayout()
    return self
  }
}
