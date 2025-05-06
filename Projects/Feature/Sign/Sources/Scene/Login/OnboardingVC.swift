import UIKit

import DesignSystem
import BaseFeature

final class OnboardingVC: BaseVC {
  private let pageNumber: Int
  
  init(pageNumber: Int) {
    self.pageNumber = pageNumber
    super.init()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  override func setupUI() {
    super.setupUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .backgroundColor(Colors.Gray._1)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem()
          .justifyContent(.center)
          .alignItems(.center)
          .define { flex in
          flex.addItem(UILabel().text(subTitleLabel, font: Fonts.body._2, color: Colors.Blue._4))
            .marginBottom(4)
          flex.addItem(UILabel().text(titleLabel, font: Fonts.heading._4, color: Colors.Gray._8))
          }.height(80)
        flex.addItem(UIImageView(image: image))
      }
  }
}

extension OnboardingVC {
  var titleLabel: String? {
    switch self.pageNumber {
    case 0: "장부 기록을 가볍게 시작해보세요"
    case 1: "필요한 만큼 장부를 여러 개 만들 수 있어요"
    case 2: "장부를 친구와 함께 관리할 수 있어요"
    default: nil
    }
  }
  
  var subTitleLabel: String? {
    switch self.pageNumber {
    case 0: "장부 기록"
    case 1: "장부 추가"
    case 2: "친구 초대"
    default: nil
    }
  }
  
  var image: UIImage? {
    switch self.pageNumber {
    case 0: Images.onboardingFirst
    case 1: Images.onboardingSecond
    case 2: Images.onboardingThird
    default: nil
    }
  }
}
