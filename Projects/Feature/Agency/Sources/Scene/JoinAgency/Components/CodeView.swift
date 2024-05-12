import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import PinLayout
import FlexLayout

final class CodeView: UIView {
  enum State {
    case plain // 입력대기
    case focused // 입력중
    case done // 입력완료
    case error // 에러
  }
  
  private var disposeBag = DisposeBag()
  private let rootContainer = UIView()
  private let mongCodeImageView: UIImageView = {
    let v = UIImageView(image: Images.mongCode)
    v.backgroundColor = Colors.Gray._1
    return v
  }()
  
  let numberTextField: UITextField = {
    let v = UITextField()
    v.keyboardType = .numberPad
    v.font = Fonts.heading._1
    v.textColor = Colors.Black._1
    v.tintColor = .clear
    return v
  }()
  
  init(state: State) {
    super.init(frame: .zero)
    setupConstraints()
    setState(state)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    mongCodeImageView.pin.all()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    addSubview(mongCodeImageView)
    
    rootContainer.flex
      .justifyContent(.center).alignItems(.center)
      .cornerRadius(10).define { flex in
        flex.addItem(numberTextField).marginLeft(10).width(20).height(100%)
      }
  }
  
  func setState(_ state: State) {
    switch state {
    case .plain:
      rootContainer.flex.border(1, Colors.Gray._3).backgroundColor(Colors.White._1)
      mongCodeImageView.isHidden = true
    case .focused:
      rootContainer.flex.border(1, Colors.Blue._4).backgroundColor(Colors.White._1)
      numberTextField.becomeFirstResponder()
      mongCodeImageView.isHidden = true
    case .done:
      rootContainer.flex.border(0, Colors.White._1).backgroundColor(Colors.White._1)
      mongCodeImageView.isHidden = false
    case .error:
      rootContainer.flex.border(1, Colors.Red._3).backgroundColor(Colors.Gray._1)
      mongCodeImageView.isHidden = true
    }
  }
}
