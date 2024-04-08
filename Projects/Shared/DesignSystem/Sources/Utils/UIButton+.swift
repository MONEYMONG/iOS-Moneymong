import UIKit

public extension UIButton {
  func addAction(_ action: @escaping () -> Void) {
    addAction(UIAction(handler: { _ in
      action()
    }), for: .touchUpInside)
  }
}
