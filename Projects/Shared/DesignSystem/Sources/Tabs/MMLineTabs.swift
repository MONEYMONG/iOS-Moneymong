import UIKit

import PinLayout

final class MMLineTabs: UISegmentedControl {
  private var underlineView: UIView!
  private var dividerView: UIView!
  
  override init(items: [Any]?) {
    super.init(items: items)
    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dividerView.frame = CGRect(
      x: 0,
      y: bounds.size.height - 0.5,
      width: bounds.size.width,
      height: 1.0
    )
    self.changeUnderlinePosition()
  }
  
  private func setupView() {
    underlineView = UIView()
    underlineView.backgroundColor = Colors.Blue._4
    dividerView = UIView()
    dividerView.backgroundColor = Colors.Gray._3
    clipsToBounds = false
    
    setTitleTextAttributes(
      [
        .foregroundColor: Colors.Gray._10,
        .font: Fonts.body._3
      ],
      for: .selected
    )
    setTitleTextAttributes(
      [
        .foregroundColor: Colors.Gray._4,
        .font: Fonts.body._3
      ],
      for: .normal
    )
  }
  
  private func setupConstraints() {
    addSubview(dividerView)
    addSubview(underlineView)
    setBackgroundImage(.init(), for: .normal, barMetrics: .default)
    setBackgroundImage(.init(), for: .selected, barMetrics: .default)
    setBackgroundImage(.init(), for: .highlighted, barMetrics: .default)
    setDividerImage(.init(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
  }
  
  private func changeUnderlinePosition() {
    let width = bounds.size.width / CGFloat(numberOfSegments)
    let height = 2.0
    let xPosition = CGFloat(selectedSegmentIndex) * width
    let yPosition = bounds.size.height - 1.0
    let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
    
    UIView.animate(withDuration: 0.1) {
      self.underlineView.frame = frame
    }
  }
}

