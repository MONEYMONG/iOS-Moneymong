import UIKit

public extension UIView {
  func removeAllSubViews() {
    self.subviews.forEach { $0.removeFromSuperview() }
  }
}
