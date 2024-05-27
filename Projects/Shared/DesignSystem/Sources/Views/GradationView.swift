import UIKit

public final class GradationView: UIView {
  let gradientLayer = CAGradientLayer()
    
  public init() {
    super.init(frame: .zero)
  }
  
  public func setGradation(colors: [CGColor], location: [NSNumber]) {
    gradientLayer.colors = colors
    gradientLayer.locations = location
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
    layer.addSublayer(gradientLayer)
  }
}
