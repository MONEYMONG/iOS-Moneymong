import UIKit

import FlexLayout
import PinLayout

final class MMSnackBar: UIView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.White._1
    v.font = Fonts.body._3
    return v
  }()
  
  private let rightButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
    let image = Images.close?
      .withRenderingMode(.alwaysTemplate).withConfiguration(imageConfig)
    button.setTitleColor(.red, for: .normal)
    button.setImage(image, for: .normal)
    button.tintColor = .white
    return button
  }()
  
  private let rootContainer = UIView()
  
  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupView() {
    alpha = 0.1
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.backgroundColor(Colors.Gray._7).cornerRadius(8).define { flex in
      flex.addItem().direction(.row).define { flex in
        flex.addItem(titleLabel).grow(1).marginVertical(14).marginLeft(16)
        flex.addItem(rightButton).marginRight(12)
      }
    }
  }
  
  func configure(title: String, action: (() -> Void)? = nil) {
    rightButton.addAction {
      action?()
      SnackBarManager.remove()
    }
    
    // retry 일때
    if let action {
      rightButton.addAction { action() }
      rightButton.setImage(nil, for: .normal)
      rightButton.setTitle("retry", for: .normal)
      rightButton.flex.marginRight(20)
    }
    // close 일떄
    else {
      let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
      let image = UIImage(resource: .close)
        .withRenderingMode(.alwaysTemplate).withConfiguration(imageConfig)
      rightButton.setImage(image, for: .normal)
      rightButton.setTitle("", for: .normal)
      rightButton.flex.marginRight(12)
    }
    
    rightButton.flex.markDirty()
    titleLabel.text = title
    titleLabel.flex.markDirty()
    setNeedsLayout()
  }
}
