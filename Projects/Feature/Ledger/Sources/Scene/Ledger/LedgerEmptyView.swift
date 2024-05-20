import UIKit

import DesignSystem

import FlexLayout
import PinLayout

import RxCocoa
import RxSwift

final class LedgerEmptyView: UIView {
  
  private let rootContainer = UIView()
  
  private let iconImageView = UIImageView(image: Images.mongStudy)
  
  private let contentLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._8
    v.font = Fonts.body._4
    v.setTextWithLineHeight(text: "소속에 가입후 장부를 사용할 수 있습니다.", lineHeight: 24)
    return v
  }()
  
  private let agencyButton = MMButton(title: "내 소속 찾으러 가기", type: .primary)
  
  init() {
    super.init(frame: .zero)
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center).alignItems(.center)
      .backgroundColor(Colors.White._1)
      .define { flex in
      flex.addItem(iconImageView).height(100).marginBottom(12)
      flex.addItem(contentLabel).marginBottom(16)
      flex.addItem(agencyButton).height(44)
    }
  }
}

extension LedgerEmptyView {
  var tapAgency: ControlEvent<Void> {
    return agencyButton.rx.tap
  }
}
