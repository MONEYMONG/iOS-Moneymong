import Foundation

import FirebaseCore
import FirebaseAnalytics

public class FirebaseManager: NSObject {
  public static var shared = FirebaseManager()

  public func initSDK() {
    FirebaseApp.configure()
//    Messaging.messaging().delegate = self
  }

  public func logEvent(name: String) {
    Analytics.logEvent(name, parameters: nil)
  }
}

//extension FirebaseManager: MessagingDelegate {
//  public func messaging(
//    _ messaging: Messaging,
//    didReceiveRegistrationToken fcmToken: String?
//  ) {
//    if let fcmToken = fcmToken {
//      KeychainService.shared.setItem(key: .fcmToken, value: fcmToken)
//    }
//
//    let dataDict: [String: String] = ["token": fcmToken ?? ""]
//    NotificationCenter.default.post(
//      name: Notification.Name("FCMToken"),
//      object: nil,
//      userInfo: dataDict
//    )
//  }
//}
