import UIKit

import DesignSystem

import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

extension EmptyAgencyView {
  var isVisable: Binder<Bool> {
    return Binder(self) { owner, value in
      owner.flex.display(value ? .flex : .none)
      owner.isHidden = !value
      owner.setNeedsLayout()
    }
  }
}

final class EmptyAgencyView: UIView {
  
  private let iconImageView = UIImageView(image: Images.agency)
  
  private let descriptionLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "아직 등록된 소속이 없어요\n하단 버튼을 통해 등록해보세요", lineHeight: 24)
    v.textAlignment = .center
    v.numberOfLines = 2
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._8
    return v
  }()
  
  private let rootContainer = UIView()
  
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
    
    rootContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
      flex.addItem(iconImageView).size(80).marginBottom(8)
      flex.addItem(descriptionLabel)
    }
  }
}
