import UIKit

import DesignSystem

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

final class EditMemberListView: UIView {
  
  private let rootContainer = UIView()
  
  private let roleView = UIView()
  private let kickOffView = UIView()
  
  private let roleLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "역할지정", lineHeight: 24)
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._8
    return v
  }()
  
  private let arrowRightImageView = UIImageView(image: Images.arrowRight)
  
  private let kickOffLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "내보내기", lineHeight: 24)
    v.font = Fonts.body._4
    v.textColor = Colors.Red._3
    return v
  }()
  
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
    rootContainer.flex.padding(20, 20, 46).define { flex in
      flex.addItem(roleView).direction(.row).alignItems(.center).define { flex in
        flex.addItem(roleLabel)
        flex.addItem().grow(1)
        flex.addItem(arrowRightImageView).size(24)
      }.marginBottom(20)
      
      flex.addItem(kickOffView).define { flex in
        flex.addItem(kickOffLabel)
      }
    }
  }
}

extension EditMemberListView {
  var tapRole: ControlEvent<UIView> {
    return roleView.rx.tapGesture
  }
  
  var tapKickOff: ControlEvent<UIView> {
    return kickOffView.rx.tapGesture
  }
}
