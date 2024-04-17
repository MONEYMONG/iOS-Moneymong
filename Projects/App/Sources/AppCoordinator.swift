import UIKit

import BaseFeature
import MainFeature
import SignFeature

final class AppCoordinator: Coordinator {  
  var navigationController: UINavigationController
  var diContainer: AppDIContainer = AppDIContainer()
  weak var parentCoordinator: (BaseFeature.Coordinator)?
  var childCoordinators: [BaseFeature.Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(animated: Bool) {
    sign(animated: animated)
  }

  func move(to scene: Scene) {
    switch scene {
    case .main:
      main(animated: true)
    }
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
