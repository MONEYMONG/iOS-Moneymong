import UIKit

import DesignSystem
import Utility

import RxSwift
import FlexLayout
import PinLayout

final class AddImageButtonCell: UICollectionViewCell, ReusableView {
  private let rootContainer = UIView()

  private let imageView: UIImageView = {
    let v = UIImageView()
    v.image = Images.plusCircleFillBlue
    return v
  }()

  private let disposeBag = DisposeBag()

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
