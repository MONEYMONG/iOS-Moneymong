import UIKit

import NetworkService
import MyPageFeature
import DesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var coordinator: MyPageCoordinator!
  var diContainer: MyPageDIContainer!
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    Fonts.registerFont()
    let rootNavigation = UINavigationController()
    
    self.diContainer = MyPageDIContainer(userRepo: UserRepository())
    self.coordinator = MyPageCoordinator(navigationController: rootNavigation, diContainer: diContainer)
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = rootNavigation
    window?.makeKeyAndVisible()
    
    self.coordinator.start(animated: true)
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}
