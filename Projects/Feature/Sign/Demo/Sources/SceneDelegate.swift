import UIKit

import AuthInterface
import AgencyInterface
import AgencyTesting
import AuthTesting
import BaseFeature
import SignFeature
import DesignSystem


final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var appCoordinator: SignCoordinator?

  func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    let navigationController = UINavigationController()
    Fonts.registerFont()
    registerDependency()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = navigationController

    self.appCoordinator = SignCoordinator(navigationController: navigationController)
    appCoordinator?.start(animated: false)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {}

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
  func registerDependency() {
    DIContainer.shared.register(type: AutoSignUseCaseInterface.self) {
      return MockAutoSignUseCase()
    }
    
    DIContainer.shared.register(type: SignUpUseCaseInterface.self) {
      return MockSignUpUseCase()
    }
    
    DIContainer.shared.register(type: GetRecentLoginInfoUseCaseInterface.self) {
      return MockGetRecentLoginInfoUseCase()
    }
    
    DIContainer.shared.register(type: GetMyAgencyUseCaseInterface.self) {
      return MockGetMyAgencyUseCase()
    }
  }
}
