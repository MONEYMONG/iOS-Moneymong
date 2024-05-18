import UIKit

import DesignSystem
import Utility

final class AddImageCell: UICollectionViewCell, ReusableView {
  private let rootContainer = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
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

  private func setupView() {
    clipsToBounds = true
    layer.cornerRadius = 8
    layer.borderWidth = 1
    layer.borderColor = Colors.Blue._3.cgColor
  }
  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
      flex.addItem(UIImageView(image: Images.plusCircleFillBlue))
    }
  }
}
