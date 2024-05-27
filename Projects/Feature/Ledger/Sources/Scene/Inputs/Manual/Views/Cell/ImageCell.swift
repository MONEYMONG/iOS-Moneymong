import UIKit

import DesignSystem
import Utility

final class ImageCell: UICollectionViewCell, ReusableView {
  
  private var itme: ImageSectionModel.Item?
  private let rootContainer = UIView()
  private let deleteButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.closeFill, for: .normal)
    return v
  }()
  private let imageView: UIImageView = {
    let v = UIImageView()
    v.layer.cornerRadius = 8
    v.clipsToBounds = true
    v.contentMode = .scaleAspectFill
    return v
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
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
  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(imageView)
        flex.addItem(deleteButton)
          .position(.absolute)
          .top(-6)
          .right(-6)
    }
  }

  func configure(with item: ImageSectionModel.Item, action: @escaping (ImageSectionModel.Item) -> Void) -> Self {
    guard case let .image(image, _) = item else { return self }
    self.itme = item
    imageView.image = UIImage(data: image.data)
    deleteButton.addAction {
      action(item)
    }
    return self
  }
}
