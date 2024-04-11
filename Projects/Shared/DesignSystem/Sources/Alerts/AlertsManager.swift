import UIKit

public final class AlertsManager {
  /// cancelAction과 subTitle은 값이 nil인 경우 UI 표시 X
  public static func show(
    _ vc: UIViewController,
    title: String,
    subTitle: String?,
    okAction: @escaping () -> Void,
    cancelAction: (() -> Void)?
  ) {
    let alert = MMAlerts(
      title: title,
      subTitle: subTitle,
      okAction: okAction,
      cancelAction: cancelAction
    )
    alert.modalPresentationStyle = .overFullScreen
    alert.modalTransitionStyle = .crossDissolve
    vc.present(alert, animated: true)
  }
}
