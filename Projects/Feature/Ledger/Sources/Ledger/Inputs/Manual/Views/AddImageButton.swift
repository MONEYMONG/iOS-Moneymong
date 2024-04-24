import UIKit

import DesignSystem

final class AddImageButton: UIButton {
  private let plusIcon = UIImageView(image: Images.plusCircleFill)
  
  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    flex.layout()
  }

  private func setupView() {
    clipsToBounds = true
    layer.cornerRadius = 8
    layer.borderWidth = 1
    layer.borderColor = Colors.Blue._3.cgColor
  }
  
  private func setupConstraints() {
    let width = UIScreen.main.bounds.width * 0.28
    let height = width * 1.33
    
    self.flex
      .width(width)
      .height(height)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
      flex.addItem(plusIcon)
    }
  }
}
