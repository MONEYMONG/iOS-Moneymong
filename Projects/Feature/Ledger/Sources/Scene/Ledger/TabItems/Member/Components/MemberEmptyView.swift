import UIKit

import DesignSystem

import FlexLayout
import PinLayout

final class MemberEmptyView: UIView {
  
  private let rootContainer = UIView()
  private let iconImageView = UIImageView(image: Images.mongCongrats)
  private let contentLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "아직 멤버가 없습니다", lineHeight: 20)
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._6
    return v
  }()
  
  init() {
    super.init(frame: .zero)
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
      flex.addItem(iconImageView).size(100).marginBottom(4)
      flex.addItem(contentLabel)
    }
  }
}
