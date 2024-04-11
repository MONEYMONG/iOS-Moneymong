import UIKit

import BaseFeature
import MainFeature

final class AppCoordinator: Coordinator {  
  var navigationController: UINavigationController
  var diContainer: BaseFeature.DIContainerInterface = AppDIContainer()
  weak var parentCoordinator: (BaseFeature.Coordinator)?
  var childCoordinators: [BaseFeature.Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(animated: Bool) {
    main(animated: animated)
  }
}

extension AppCoordinator {
  func sign(animated: Bool) {

  }

  func main(animated: Bool) {
    let mainTabCoordinator = MainTabBarCoordinator(
      navigationController: navigationController,
      diContainer: diContainer
    )
    mainTabCoordinator.start(animated: true)
    mainTabCoordinator.parentCoordinator = self
  }
}

final class AppDIContainer: DIContainerInterface {
  let mainDIContainer: MainDIContainer

  init(mainDIContainer: MainDIContainer = MainDIContainer()) {
    self.mainDIContainer = mainDIContainer
  }
}
