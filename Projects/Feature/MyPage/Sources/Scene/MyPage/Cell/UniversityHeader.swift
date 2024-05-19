import UIKit

import Utility
import DesignSystem

import Kingfisher

final class UniversityHeader: UITableViewHeaderFooterView, ReusableView {

  private let profileImageView: UIImageView = {
    let v = UIImageView()
    v.image = Images.mongBackgroundCircle
    v.layer.cornerRadius = 24
    v.clipsToBounds = true
    return v
  }()
  
  private let nameLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.heading._1
    v.textColor = Colors.Gray._10
    return v
  }()
  
  private let providerImageView: UIImageView = {
    let v = UIImageView()
    return v
  }()
  
  private let emailLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._2
    v.textColor = Colors.Gray._8
    return v
  }()
  
  private let rootContainer = UIView()
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
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
    rootContainer.flex.direction(.row).paddingBottom(20).define { flex in
      flex.addItem(profileImageView).size(48)
        .marginRight(10)
      
      flex.addItem().direction(.column).define { flex in
        flex.addItem(nameLabel)
        flex.addItem().direction(.row).define { flex in
          flex.addItem(providerImageView).size(18)
            .marginRight(4)
          flex.addItem(emailLabel)
        }
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  func configure(with item: MyPageSectionItemModel.Section) -> Self {
    guard case let .account(model) = item else { return self}
    
    nameLabel.setTextWithLineHeight(text: model.nickname, lineHeight: 28)
    emailLabel.setTextWithLineHeight(text: model.email, lineHeight: 18)
    providerImageView.image = model.provider == "KAKAO" ? Images.kakaoTalk : Images.apple
    return self
  }
}
