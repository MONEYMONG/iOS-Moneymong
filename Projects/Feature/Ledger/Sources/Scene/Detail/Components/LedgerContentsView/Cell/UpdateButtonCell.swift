import UIKit

import DesignSystem
import Utility

final class UpdateButtonCell: UICollectionViewCell, ReusableView {

  private let rootContainer = UIView()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Images.plusCircleFillBlue
    return imageView
  }()

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

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  private func setupView() {
    clipsToBounds = true
    layer.cornerRadius = 8
  }

  private func setupConstraints() {
    contentView.addSubview(rootContainer)

    rootContainer.flex
      .backgroundColor(Colors.Blue._1)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(imageView)
      }
  }
}
