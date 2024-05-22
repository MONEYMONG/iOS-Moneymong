import UIKit

public extension UIView {
  enum VerticalLocation {
    case bottom
    case top
    case left
    case right
    case center
  }

  func setShadow(
    location: VerticalLocation,
    color: UIColor = .black,
    opacity: Float = 0.3,
    radius: CGFloat = 5.0
  ) {
    switch location {
    case .bottom:
      addShadow(
        offset: CGSize(width: 0, height: 2),
        color: color,
        opacity: opacity,
        radius: radius
      )
    case .top:
      addShadow(
        offset: CGSize(width: 0, height: -2),
        color: color,
        opacity: opacity,
        radius: radius
      )
    case .left:
      addShadow(
        offset: CGSize(width: -2, height: 0),
        color: color,
        opacity: opacity,
        radius: radius
      )
    case .right:
      addShadow(
        offset: CGSize(width: 2, height: 0),
        color: color,
        opacity: opacity,
        radius: radius
      )
    case .center:
      addShadow(
        offset: CGSize(width: 0, height: 0),
        color: color,
        opacity: opacity,
        radius: radius
      )
    }
  }

  private func addShadow(
    offset: CGSize,
    color: UIColor = .black,
    opacity: Float = 0.1,
    radius: CGFloat = 3.0
  ) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = color.cgColor
    self.layer.shadowOffset = offset
    self.layer.shadowOpacity = opacity
    self.layer.shadowRadius = radius
  }
}
