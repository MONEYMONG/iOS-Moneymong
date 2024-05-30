import UIKit

import DesignSystem
import Utility

final class ImageCell: UICollectionViewCell, ReusableView {
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
  
  private var buttonAction: () -> Void = {}
  
  override init(frame: CGRect) {
    super.init(frame: frame)
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
    deleteButton.addAction { [weak self] in
      guard let self else { return }
      buttonAction()
    }
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

  func configure(
    with item: ImageData.Item,
    action: @escaping () -> Void
  ) -> Self {
    guard case let .image(image) = item else { return self }
    imageView.image = UIImage(data: image.data)
    self.buttonAction = action
    return self
  }
}
