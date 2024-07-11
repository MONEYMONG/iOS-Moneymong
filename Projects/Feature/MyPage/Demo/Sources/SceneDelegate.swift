import UIKit

import Core
import MyPageFeature
import DesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var coordinator: MyPageCoordinator!
  var diContainer: MyPageDIContainer!
  
  private let localStorage: LocalStorageInterface = LocalStorage()
  
  private lazy var networkManager: NetworkManagerInterfacae = {
    let manager = NetworkManager()
    manager.tokenIntercepter = .init(
      localStorage: localStorage,
      tokenRepository: TokenRepository(networkManager: manager, localStorage: localStorage))
    
    return manager
  }()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    Fonts.registerFont()
    let rootNavigation = UINavigationController()
    
    self.diContainer = MyPageDIContainer(localStorage: LocalStorage(), networkManager: NetworkManager())
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
