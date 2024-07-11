import Foundation

//import FirebaseCore
//import FirebaseAnalytics

public class FirebaseManager: NSObject {
  public static var shared = FirebaseManager()

  public func initSDK() {
//    FirebaseApp.configure()
  }

  public func setUser(id: String) {
//    Analytics.setUserID(id)
  }

  public func logEvent(name: String) {
//    Analytics.logEvent(name, parameters: nil)
  }
}
