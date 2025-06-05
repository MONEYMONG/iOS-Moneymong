import UIKit

import AgencyInterface
import AgencyTesting
import AgencyFeature
import AgencyFeatureInterface
import DesignSystem
import BaseFeature
import AuthInterface
import AuthTesting
import UserInterface
import UserTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var coordinator: CreateAgencyCoordinator?
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    Fonts.registerFont()
    registerDependency()
    let navigationController = UINavigationController()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    coordinator = CreateAgencyCoordinator(ledgerService: nil)
    coordinator?.navigationController = navigationController
    coordinator?.start(animated: false)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
  func registerDependency() {
    DIContainer.shared.register(type: CreateAgencyUseCaseInterface.self) {
      return MockCreateAgencyUseCase()
    }
    
    DIContainer.shared.register(type: DeleteUserUseCaseInterface.self) {
      return MockDeleteUserUseCase()
    }
    
    DIContainer.shared.register(type: UpdateSelectedAgencyUseCaseInterface.self) {
      return MockUpdateSelectedAgencyUseCase()
    }
  }
}
