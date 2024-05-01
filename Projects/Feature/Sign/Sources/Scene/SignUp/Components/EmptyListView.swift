import UIKit

import DesignSystem

final class EmptyListView: UIView {
  private let schoolImageView: UIImageView = {
    let image = Images.university
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.setTextWithLineHeight(text: Const.title, lineHeight: 20)
    label.font = Fonts.body._3
    label.textColor = Colors.Gray._5
    return label
  }()

  private let rootContainer = UIView()

  init() {
    super.init(frame: .zero)
    setupUI()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex
      .alignItems(.center)
      .define { flex in
        flex.addItem().height(32)
        flex.addItem(schoolImageView).width(52).height(52)
        flex.addItem().height(4)
        flex.addItem(titleLabel)
      }
  }
}


fileprivate enum Const {
  static var title: String { "검색 결과가 없습니다" }
}
