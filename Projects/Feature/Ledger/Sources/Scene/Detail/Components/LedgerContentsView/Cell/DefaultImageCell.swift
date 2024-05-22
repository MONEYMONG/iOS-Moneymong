import UIKit

import DesignSystem
import Utility

import RxSwift
import Kingfisher

final class DefaultImageCell: UICollectionViewCell, ReusableView {
  private let rootContainer = UIView()

  private let imageView: UIImageView = {
    let v = UIImageView()
    v.layer.cornerRadius = 8
    v.clipsToBounds = true
    v.contentMode = .scaleAspectFill
    return v
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

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  private func setupView() {
    contentView.addSubview(rootContainer)
  }

  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(imageView)
          .border(1, Colors.Blue._1)
        //    flex.addItem(deleteButton)
        //     .position(.absolute)
        //     .top(-6)
        //     .right(-6)
      }
  }

  func configure(with urlString: String) -> Self {
    guard let url = URL(string: urlString) else {
      return self
    }
    imageView.kf.indicatorType = .activity
    imageView.kf.setImage(
      with: KF.ImageResource(
        downloadURL: url,
        cacheKey: urlString
      )
    )
    imageView.flex.markDirty()
    setNeedsLayout()
    return self
  }
}
