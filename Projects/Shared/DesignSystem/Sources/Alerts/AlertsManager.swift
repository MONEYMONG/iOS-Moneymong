import UIKit

public final class AlertsManager {
  /// cancelAction과 subTitle은 값이 nil인 경우 UI 표시 X
  public static func show(
    _ target: UIViewController,
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
    
    target.present(alert, animated: true)
  }
}
