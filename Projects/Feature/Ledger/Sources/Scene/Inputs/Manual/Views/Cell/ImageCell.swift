import UIKit

import DesignSystem
import Utility

import RxSwift

final class ImageCell: UICollectionViewCell, ReusableView {
  private let disposeBag = DisposeBag()
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
    setupView()
    setupConstraints()
    bind()
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

  private func setupView() {}
  
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
  
  private func bind() {
    deleteButton.rx.tap
      .bind(with: self) { owner, _ in
        NotificationCenter.default.post(name: .didTapImageDeleteButton, object: owner.itme)
      }.disposed(by: disposeBag)
  }
  
  func configure(with item: ImageSectionModel.Item) -> Self {
    guard case let .image(image, _) = item else { return self }
    self.itme = item
    imageView.image = UIImage(data: image.data)
    return self
  }
}
