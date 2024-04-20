import UIKit

import Utils
import DesignSystem

final class SettingCell: UITableViewCell, ResuableView {
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
      flex.addItem(titleLabel)
      flex.addItem(UIView()).grow(1)
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
  func configure(with item: MyPageSectionItem) -> Self {
    switch item {
    case .university: break
    case .service:
      iconImageView.image = Images.paper?.withRenderingMode(.alwaysTemplate)
      titleLabel.setTextWithLineHeight(text: "서비스 이용약관", lineHeight: 24)
      disclosureIndicator.flex.isIncludedInLayout(true).markDirty()
      versionLabel.flex.isIncludedInLayout(false).markDirty()
    case .privacy:
      iconImageView.image = Images.document?.withRenderingMode(.alwaysTemplate)
      titleLabel.setTextWithLineHeight(text: "개인정보 처리 방침", lineHeight: 24)
      disclosureIndicator.flex.isIncludedInLayout(true).markDirty()
      versionLabel.flex.isIncludedInLayout(false).markDirty()
    case .withdrawl:
      iconImageView.image = Images.trash?.withRenderingMode(.alwaysTemplate)
      titleLabel.setTextWithLineHeight(text: "회원탈퇴", lineHeight: 24)
      disclosureIndicator.flex.isIncludedInLayout(true).markDirty()
      versionLabel.flex.isIncludedInLayout(false).markDirty()
    case .logout:
      iconImageView.image = Images.logout?.withRenderingMode(.alwaysTemplate)
      titleLabel.setTextWithLineHeight(text: "로그아웃", lineHeight: 24)
      disclosureIndicator.flex.isIncludedInLayout(false).markDirty()
      versionLabel.flex.isIncludedInLayout(false).markDirty()
    case .version:
      iconImageView.image = Images.warning?.withRenderingMode(.alwaysTemplate)
      titleLabel.setTextWithLineHeight(text: "버전정보", lineHeight: 24)
      versionLabel.setTextWithLineHeight(text: "1.0.0", lineHeight: 24)
      disclosureIndicator.flex.isIncludedInLayout(false).markDirty()
      versionLabel.flex.isIncludedInLayout(true).markDirty()
    }
    
    contentView.setNeedsLayout()
    return self
  }
}
