import UIKit

import DesignSystem
import NetworkService

import RxSwift

final class GradeInputView: UIView {
  private let schoolImageView: UIImageView = {
    let image = Images.university
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.body._4
    label.textColor = Colors.Gray._10
    return label
  }()

  private let unSelectButton: UIButton = {
    let button = UIButton()
    button.setImage(Images.pencilGray, for: .normal)
    return button
  }()

  private let gradeDescriptionLabel: UILabel = {
    let label = UILabel()
    label.setTextWithLineHeight(text: Const.gradeDescription, lineHeight: 18)
    label.font = Fonts.body._2
    label.textColor = Colors.Gray._6
    return label
  }()

  private let gradeSelections = MMSegmentControl(
    titles: Const.gradeItems,
    type: .round
  )

  private let rootContainer = UIView()

  var didTapUnSelectButton: Observable<Void> {
    unSelectButton.rx.tap.asObservable()
  }

  var didTapSelectGrade: Published<Int>.Publisher {
    gradeSelections.$selectedIndex
  }
  
  var selectedIndex: Int {
    get { gradeSelections.selectedIndex }
    set { gradeSelections.selectedIndex = newValue }
  }

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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  private func setupConstraints() {
    rootContainer.flex.define { flex in
      flex.addItem()
        .alignItems(.center)
        .direction(.row)
        .define { flex in
          flex.addItem(schoolImageView).height(22).width(22)
          flex.addItem().width(10)
          flex.addItem(nameLabel).grow(1)
          flex.addItem(unSelectButton).height(24).width(24)
        }

      flex.addItem().height(32)
      flex.addItem(gradeDescriptionLabel)

      flex.addItem().height(8)
      flex.addItem(gradeSelections)
    }
  }

  @discardableResult
  func configure(university: University) -> Self {
    gradeSelections.selectedIndex = -1
    nameLabel.text = university.schoolName
    nameLabel.flex.markDirty()
    nameLabel.setNeedsLayout()
    return self
  }
}


fileprivate enum Const {
  static var gradeItems: [String] { ["1학년", "2학년", "3학년", "4학년", "5학년이상"] }
  static var gradeDescription: String { "학년을 선택해주세요" }
}
