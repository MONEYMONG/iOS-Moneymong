import UIKit

import PinLayout
import FlexLayout

public class TagView: UIView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._2
    v.text = "기본"
    return v
  }()
  
  private let rootContainer = UIView()

  public init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    clipsToBounds = true
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex
      .justifyContent(.center)
      .define { flex in
      flex.addItem(titleLabel)
        .marginHorizontal(8)
        .marginTop(2)
        .marginBottom(2)
    }
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  
    rootContainer.pin.all()
    rootContainer.flex.layout()
    
    layer.cornerRadius = frame.height / 2
  }
  
  public func configure(
    title: String,
    titleColor: UIColor,
    backgroundColor: UIColor
  ) {
    titleLabel.setTextWithLineHeight(text: title, lineHeight: 17)
    titleLabel.textColor = titleColor
    self.backgroundColor = backgroundColor
    
    titleLabel.flex.markDirty()
    setNeedsLayout()
  }
}
