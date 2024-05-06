import UIKit

extension UIWindow {
  public static var firstWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
  }
}
