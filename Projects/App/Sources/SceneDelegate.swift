import UIKit

import Core
import DesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  private let localStorage = LocalStorage()
  private let networkManager = NetworkManager()
  private lazy var diContainer = AppDIContainer(localStorage: localStorage, networkManager: networkManager)
  
  private var appCoordinator: AppCoordinator?
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    Fonts.registerFont()

    let navigationController = UINavigationController()
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = navigationController
    
    self.appCoordinator = AppCoordinator(
      navigationController: navigationController,
      diContainer: diContainer
    )
    appCoordinator?.start(animated: false)
    
    self.scene(scene, openURLContexts: connectionOptions.urlContexts)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }

    if url.absoluteString.contains("widget://") {
      DeepLinkManager.setDestination(url.absoluteString, agencyID: localStorage.selectedAgency)
    } else {
      KakaoAuthManager.shared.openURL(url)
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}
