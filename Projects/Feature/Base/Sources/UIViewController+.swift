import UIKit
import SafariServices

import DesignSystem

public extension UIViewController {
  func showAlert(title: String, subTitle: String? = nil, type: MMAlerts.`Type`) {
    AlertsManager.show(self, title: title, subTitle: subTitle, type: type)
  }
  
  func showSafari(urlString: String, animated: Bool = true) {
    guard let url = URL(string: urlString) else {
      return debugPrint("Invalid URL", #function)
    }
    
    let vc = SFSafariViewController(url: url)
    self.present(vc, animated: animated)
  }
  
  func showSnackBar(
    title: String,
    action: (() -> Void)? = nil,
    impact: UINotificationFeedbackGenerator.FeedbackType = .success
  ) {
    SnackBarManager.show(self.view, title: title, action: action, impact: impact)
  }
}
