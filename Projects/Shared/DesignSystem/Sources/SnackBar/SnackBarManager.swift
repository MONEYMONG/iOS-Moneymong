import UIKit

import Utility

@MainActor
public final class SnackBarManager {
  
  static var bottomConstraints: NSLayoutConstraint?
  
  /// snackBar를 애니메이션과 함께 보여줌
  public static func show(
    title: String,
    action: (() -> Void)? = nil,
    impact: UINotificationFeedbackGenerator.FeedbackType = .success
  ) {
    let snackBar = MMSnackBar()
    snackBar.configure(title: title, action: action)
    HapticManager.shared.hapticNotification(type: impact)

    guard let view = UIWindow.firstWindow?.rootViewController?.topViewController().view else {
      return
    }
    
    print("topview: \(view)")
    
    if let previousSnackBar = view.subviews.first(where: { $0 is MMSnackBar }) {
      UIView.animate(withDuration: 0.3) {
        previousSnackBar.alpha = 0.1
      } completion: { _ in
        previousSnackBar.removeFromSuperview()
      }
    }
    
    snackBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(snackBar)

    bottomConstraints = snackBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100)
    bottomConstraints?.isActive = true

    NSLayoutConstraint.activate([
      snackBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      snackBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      snackBar.heightAnchor.constraint(equalToConstant: 48)
    ])
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      bottomConstraints?.constant = -12
      snackBar.alpha = 0.1
      
      UIView.animate(withDuration: 0.3) {
        snackBar.alpha = 1.0
        view.layoutIfNeeded()
      } completion: { _ in
        if action == nil {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            remove()
          }
        }
      }
    }
  }
  
  /// snackbar를 애니메이션과 함께 지움  (MMSnackBar에서 호출)
  public static func remove() {
    guard let view = UIWindow.firstWindow?.rootViewController?.topViewController().view else {
      return
    }
    
    guard let snackBar = view.subviews.first(where: { $0 is MMSnackBar }) else {
      return
    }
    
    bottomConstraints?.constant = 100
    snackBar.alpha = 1.0
    
    UIView.animate(withDuration: 0.3) {
      snackBar.alpha = 0.1
      view.layoutIfNeeded()
    } completion: { _ in
      snackBar.removeFromSuperview()
    }
  }
}
