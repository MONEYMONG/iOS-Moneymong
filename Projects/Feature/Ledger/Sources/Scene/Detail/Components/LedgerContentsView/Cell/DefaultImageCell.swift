import UIKit

import DesignSystem
import Utility
import NetworkService

import RxSwift
import RxCocoa
import Kingfisher

final class DefaultImageCell: UICollectionViewCell, ReusableView {
  private let rootContainer = UIView()

  private let imageView: UIImageView = {
    let v = UIImageView()
    v.layer.cornerRadius = 8
    v.clipsToBounds = true
    v.contentMode = .scaleAspectFill
    v.kf.indicatorType = .activity
    return v
  }()

  private let deleteButton: UIButton = {
    let v = UIButton()
    v.isHidden = true
    v.setImage(Images.closeFill, for: .normal)
    return v
  }()

  private var item: LedgerImageInfo?

  private let disposeBag = DisposeBag()

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

        flex.addItem(deleteButton)
          .position(.absolute)
          .top(-6)
          .right(-6)
      }
  }

  private func bind() {
    NotificationCenter.default.rx.notification(.didContentViewUpdateState)
      .compactMap { $0.object as? LedgerContentsView.State }
      .bind(with: self) { owner, state in
        owner.deleteButton.isHidden = state == .read ? true : false
        owner.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    deleteButton.rx.tap
      .bind(with: self) { owner, _ in
        NotificationCenter.default.post(
          name: .didTapLedgerDetailImageDeleteButton,
          object: owner.item
        )
      }
      .disposed(by: disposeBag)
  }

  func configure(with item: LedgerImageInfo) -> Self {
    self.item = item

    if let url = URL(string: item.url) {
      imageView.kf.setImage(
        with: KF.ImageResource(
          downloadURL: url,
          cacheKey: item.url
        )
      )
    }
    imageView.flex.markDirty()
    setNeedsLayout()
    return self
  }
}
