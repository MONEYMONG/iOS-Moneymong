import UIKit

public final class AlertsManager {
  /// cancelAction과 subTitle은 값이 nil인 경우 UI 표시 X
  public static func show(
    title: String,
    subTitle: String? = nil,
    type: MMAlerts.`Type` = .default()
  ) {
    let alert = MMAlerts(
      title: title,
      subTitle: subTitle,
      type: type
    )
    
    alert.modalPresentationStyle = .overFullScreen
    alert.modalTransitionStyle = .crossDissolve
    
    guard let vc = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .compactMap({ $0 as? UIWindowScene })
      .first?.windows
      .filter({ $0.isKeyWindow }).first?
      .rootViewController?.searchTopViewController()
    else {
      return
    }
    
    vc.present(alert, animated: true)
  }
}
