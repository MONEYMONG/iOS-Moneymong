import UIKit

import DesignSystem

public extension UIViewController {
  func showAlert(title: String, subTitle: String? = nil, type: MMAlerts.`Type`) {
    AlertsManager.show(self, title: title, subTitle: subTitle, type: type)
  }
}
