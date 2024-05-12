import UIKit

import DesignSystem
import NetworkService

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

final class MyProfileView: UIView {
  private let rootContainer = UIView()
  
  private let profileImageView = UIImageView(image: Images.mong)
  
  private let nameLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._10
    v.font = Fonts.body._4
    return v
  }()
  
  private let tagView: TagView = {
    let v = TagView()
    v.configure(title: "운영진", titleColor: Colors.White._1, backgroundColor: Colors.Blue._4)
    return v
  }()
  
  private let invitationCodeLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._10
    v.font = Fonts.body._3
    v.text = "초대 코드"
    return v
  }()
  
  private let copyButton: UIButton = {
    var title = AttributedString("복사")
    title.font = Fonts.body._3
    title.foregroundColor = Colors.Blue._4
    
    var config = UIButton.Configuration.plain()
    config.attributedTitle = title
    config.image = Images.copy?.withTintColor(Colors.Blue._4)
    config.imagePadding = 2
    config.imagePlacement = .trailing
    return UIButton(configuration: config)

  }()
  
  private let reissueCodeButton: UIButton = {
    var title = AttributedString("재발급")
    title.font = Fonts.body._3
    title.foregroundColor = Colors.Blue._4
    
    var config = UIButton.Configuration.plain()
    config.attributedTitle = title
    config.image = Images.reissue?.withTintColor(Colors.Blue._4)
    config.imagePadding = 2
    config.imagePlacement = .trailing
    return UIButton(configuration: config)
  }()
  
  init() {
    super.init(frame: .zero)
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
  
  private func setupUI() {
    
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.padding(16)
      .border(1, Colors.Gray._2).cornerRadius(16).define { flex in
      flex.addItem().direction(.row).alignItems(.center).define { flex in
        flex.addItem(profileImageView).size(44).marginRight(4)
        flex.addItem(nameLabel).marginRight(6)
        flex.addItem(tagView)
      }
      .marginBottom(12)
      
      flex.addItem().height(1).backgroundColor(Colors.Gray._2)
        .marginBottom(12)
      
      flex.addItem().direction(.row).define { flex in
        flex.addItem(invitationCodeLabel)
        flex.addItem().grow(1)
        flex.addItem(copyButton)
        flex.addItem(reissueCodeButton)
      }
    }
  }
  
  func configure(title: String, role: Member.Role, code: String) {
    nameLabel.setTextWithLineHeight(text: title, lineHeight: 24)
    switch role {
    case .staff:
      tagView.configure(
        title: "운영진",
        titleColor: Colors.White._1,
        backgroundColor: Colors.Blue._4
      )
    case .member:
      tagView.configure(
        title: "일반맴버",
        titleColor: Colors.White._1,
        backgroundColor: Colors.Mint._3
      )
    }
    invitationCodeLabel.setTextWithLineHeight(text: "초대코드 \(code)", lineHeight: 20)
    
    nameLabel.flex.markDirty()
    tagView.flex.markDirty()
    invitationCodeLabel.flex.markDirty()
    setNeedsLayout()
  }
}

extension MyProfileView {
  var tapCopy: ControlEvent<Void> {
    return copyButton.rx.tap
  }
  
  var tapReissue: ControlEvent<Void> {
    return reissueCodeButton.rx.tap
  }
}
