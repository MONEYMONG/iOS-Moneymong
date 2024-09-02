import UIKit

import Utility
import DesignSystem

import FlexLayout
import PinLayout

final class FeedbackCell: UICollectionViewCell, ReusableView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.textColor = .white
    v.text = "머니몽에게 의견 제안하기"
    return v
  }()
  
  private let tagView = TagView()
  
  private let rootContainer = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    tagView.configure(
      title: "스벅 키프티콘",
      titleColor: Colors.Blue._4,
      backgroundColor: Colors.SkyBlue._1
    )
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
    setGradient()
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  private func setGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor(hexString: "9181F6").cgColor,
      UIColor(hexString: "5562FF").cgColor,
      UIColor(hexString: "C7C2FF").cgColor,
      UIColor(hexString: "C4EAFF").cgColor
    ]
    
    gradientLayer.locations = [
      0.0,
      0.31,
      0.67,
      1.0
    ]
    
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.frame = rootContainer.bounds
    gradientLayer.cornerRadius = 16
    rootContainer.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    rootContainer.flex.direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
      flex.addItem(titleLabel).marginRight(2)
      flex.addItem(UIImageView(image: Images.feedback)).marginRight(2)
      flex.addItem(tagView).height(30)
    }
    .cornerRadius(16)
  }
}
