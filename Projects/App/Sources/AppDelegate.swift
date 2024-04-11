import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.makeKeyAndVisible()
    let navigationController = UINavigationController()
    self.window?.rootViewController = navigationController
    let appCoordinator = AppCoordinator(navigationController: navigationController)
    appCoordinator.start(animated: false)
    return true
  }
}
