import UIKit

import Utility
import DesignSystem

final class UniversityCell: UITableViewCell, ReusableView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._7
    v.font = Fonts.body._3
    v.setTextWithLineHeight(text: "학교정보", lineHeight: 20)
    return v
  }()
  
  private let iconImageView: UIImageView = {
    let v = UIImageView()
    v.image = Images.university
    v.contentMode = .scaleAspectFit
    return v
  }()
  
  private let universityLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._8
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
    selectionStyle = .none
  }
  
  private func setupConstraints() {
    rootContainer.flex.padding(20, 16).define { flex in
      flex.addItem(titleLabel)
        .marginBottom(6)
      
      flex.addItem().direction(.row).alignItems(.center).define { flex in
        flex.addItem(iconImageView).size(24).marginRight(8)
        flex.addItem(universityLabel)
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  @discardableResult
  func configure(with item: MyPageSectionItemModel.Item) -> Self {
    switch item {
    case let .university(userInfo):
      
      let universityText: String
      
      // 대학 정보가 없는경우
      if userInfo.grade == 0 {
        universityText = "정보 없음"
      }
      // 대학 정보가 있는 경우
      else {
        universityText = "\(userInfo.universityName) \(userInfo.grade)학년 \(userInfo.grade == 5 ? "이상" : "")"
      }
      
      universityLabel.setTextWithLineHeight(
        text: universityText,
        lineHeight: 24
      )
      universityLabel.flex.markDirty()
      contentView.setNeedsLayout()
    case .setting: break
    case .kakaoInquiry: break
    }
    
    return self
  }
}
