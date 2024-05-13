import UIKit

import LedgerFeature
import DesignSystem
import LocalStorage
import NetworkService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var coordinator: LedgerCoordinator?
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    Fonts.registerFont()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let networkManager = NetworkManager()
    let localStorage = LocalStorageManager()
    coordinator = LedgerCoordinator(
      navigationController: .init(),
      diContainer: .init(
        ledgerRepo: LedgerRepository(networkManager: networkManager, localStorage: localStorage),
        agencyRepo: AgencyRepository(networkManager: networkManager),
        userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage)
      )

    )
    coordinator?.start(animated: false)
    window?.rootViewController = coordinator?.navigationController
    window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}
