import UIKit

final class SmogContainer: UIView {
  let gradientLayer: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [
      UIColor.white.withAlphaComponent(0.0).cgColor,
      UIColor.white.cgColor
    ]
    gradient.locations = [0.0, 0.4]
    return gradient
  }()
    
  init() {
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
    layer.addSublayer(gradientLayer)
  }
}
