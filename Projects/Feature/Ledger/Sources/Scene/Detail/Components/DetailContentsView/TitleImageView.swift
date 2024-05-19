import UIKit

import DesignSystem
import NetworkService

import Kingfisher

final class TitleImageView: UIView {
  private let rootContainer = UIView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._2
    label.textColor = Colors.Gray._6
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._3
    label.textColor = Colors.Gray._10
    label.isHidden = true
    return label
  }()

  private let contentsView = UIView()

  private var images: [UIImageView] = []

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  func setConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.define { flex in
      flex.addItem(titleLabel)
      flex.addItem().height(8)
      flex.addItem(descriptionLabel)
      flex.addItem().direction(.row).define { flex in
        images.forEach { image in
          flex.addItem(image)
            .height(126)
            .width(95)
            .cornerRadius(8)
          flex.addItem().width(9)
        }
      }
    }
  }

  func configure(title: String, images: [LedgerDetail.ImageURL]) {
    titleLabel.setTextWithLineHeight(text: title, lineHeight: 18)
    titleLabel.flex.markDirty()

    if images.count == 0 {
      descriptionLabel.setTextWithLineHeight(text: Const.emptyItem, lineHeight: 20)
      descriptionLabel.isHidden = false
      descriptionLabel.flex.markDirty()
    } else {
      images.forEach { image in
        guard let url = URL(string: image.url) else {
          return
        }

        let imageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFill
          imageView.clipsToBounds = true
          return imageView
        }()

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
          with: KF.ImageResource(
            downloadURL: url,
            cacheKey: image.url
          )
        )
        self.images.append(imageView)
      }
    }
    setConstraints()
    setNeedsLayout()
  }
}

fileprivate enum Const {
  static var emptyItem: String { "내용없음" }
}
