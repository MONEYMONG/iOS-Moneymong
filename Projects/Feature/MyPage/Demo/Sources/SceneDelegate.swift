import UIKit

import Repository
import MyPageFeature
import DesignSystem
import BaseFeature
import UserInterface
import UserTesting
import AuthInterface
import AuthTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    Fonts.registerFont()
    registerDependency()
    let rootNavigation = UINavigationController()
    let coordinator = MyPageCoordinator()
    coordinator.navigationController = rootNavigation
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = rootNavigation
    window?.makeKeyAndVisible()
    
    coordinator.start(animated: true)
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
  func registerDependency() {
    DIContainer.shared.register(type: GetMyInfoUseCaseInterface.self) {
      return MockGetMyInfoUseCase()
    }
    
    DIContainer.shared.register(type: LogoutUseCaseInterface.self) {
      return MockLogoutUseCase()
    }
  }
}
