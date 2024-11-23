import UIKit

import BaseFeature
import MainFeature
import SignFeature
import DesignSystem

final class AppCoordinator: Coordinator {
  var navigationController: UINavigationController
  let diContainer: AppDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController, diContainer: AppDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(animated: Bool) {
    sign(animated: animated)
  }
  
  func move(to scene: Scene) {
    switch scene {
    case .main:
      main(animated: true)
    case .login:
      sign(animated: true)
    default: break
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
    print(#function)
  }
}

extension AppCoordinator {
  func sign(animated: Bool) {
    let signCoordinator = SignCoordinator(
      navigationController: navigationController,
      diContainer: diContainer.signDIContainer
    )
    signCoordinator.start(animated: true)
    signCoordinator.parentCoordinator = self
    childCoordinators.append(signCoordinator)
  }
  
  func main(animated: Bool) {
    let mainTabCoordinator = MainTabBarCoordinator(
      navigationController: navigationController,
      diContainer: diContainer.mainDIContainer
    )
    mainTabCoordinator.start(animated: true)
    mainTabCoordinator.parentCoordinator = self
    childCoordinators.append(mainTabCoordinator)
  }
}
