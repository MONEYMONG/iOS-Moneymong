import UIKit

import DesignSystem
import Utility
import Core

import Kingfisher
import ReactorKit
import FlexLayout
import PinLayout

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
    v.setImage(Images.closeFill, for: .normal)
    return v
  }()

  private var item: LedgerImageInfo?

  weak var reactor: LedgerContentsReactor?

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
          .width(100%)
          .height(100%)

        flex.addItem(deleteButton)
          .position(.absolute)
          .top(-6)
          .right(-6)
      }
  }

  func bind() {
    reactor?.pulse(\.$state)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self, onNext: { owner, state in
        switch state {
        case .read: owner.deleteButton.isHidden = true
        case .update: owner.deleteButton.isHidden = false
        }
        owner.setNeedsLayout()
      })
      .disposed(by: disposeBag)

    deleteButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self, onNext: { owner, _ in
        guard let imageInfo = owner.item else { return }
        owner.reactor?.action.onNext(.deleteImage(imageInfo))
      })
      .disposed(by: disposeBag)
  }
  
  func configure(with item: LedgerImageInfo) {
    guard let url = URL(string: item.url) else { return }

    self.item = item

    imageView.kf.setImage(
      with: KF.ImageResource(
        downloadURL: url,
        cacheKey: item.url
      )
    )

    imageView.flex.layout()
    imageView.flex.markDirty()
    setNeedsLayout()
  }
}
