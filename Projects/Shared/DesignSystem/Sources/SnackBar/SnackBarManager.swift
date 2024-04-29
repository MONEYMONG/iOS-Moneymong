import UIKit

@MainActor
public final class SnackBarManager {
  
  static var bottomConstraints: NSLayoutConstraint?
  
  /// snackBar를 애니메이션과 함께 보여줌
  public static func show(title: String, action: (() -> Void)? = nil) {
    let snackBar = MMSnackBar()
    snackBar.configure(title: title, action: action)
    
    guard let keyWindow = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .compactMap({ $0 as? UIWindowScene })
      .first?.windows
      .filter({ $0.isKeyWindow }).first
    else {
      return
    }
    
    if let previousSnackBar = keyWindow.subviews.first(where: { $0 is MMSnackBar }) {
      UIView.animate(withDuration: 0.3) {
        previousSnackBar.alpha = 0.1
      } completion: { _ in
        previousSnackBar.removeFromSuperview()
      }
    }
    
    snackBar.translatesAutoresizingMaskIntoConstraints = false
    keyWindow.addSubview(snackBar)

    bottomConstraints = snackBar.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: 100)
    bottomConstraints?.isActive = true

    NSLayoutConstraint.activate([
      snackBar.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 20),
      snackBar.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -20),
      snackBar.heightAnchor.constraint(equalToConstant: 48)
    ])
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      bottomConstraints?.constant = -12
      snackBar.alpha = 0.1
      
      UIView.animate(withDuration: 0.3) {
        snackBar.alpha = 1.0
        keyWindow.layoutIfNeeded()
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
    guard let keyWindow = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .compactMap({ $0 as? UIWindowScene })
      .first?.windows
      .filter({ $0.isKeyWindow }).first
    else {
      return
    }
    
    guard let snackBar = keyWindow.subviews.first(where: { $0 is MMSnackBar }) else {
      return
    }
    
    bottomConstraints?.constant = 100
    snackBar.alpha = 1.0
    
    UIView.animate(withDuration: 0.3) {
      snackBar.alpha = 0.1
      keyWindow.layoutIfNeeded()
    } completion: { _ in
      snackBar.removeFromSuperview()
    }
  }
}
