import UIKit

import BaseFeature
import BaseFeatureInterface
import MainFeature
import SignFeature
import SignFeatureInterface
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
    case .ledger:
      main(animated: true)
      let mainCoordinator = childCoordinators.first { $0 is MainTabBarCoordinator }
      mainCoordinator?.move(to: .ledger)
    case let .createManualLedger(id):
      main(animated: true)
      let mainCoordinator = childCoordinators.first { $0 is MainTabBarCoordinator }
      mainCoordinator?.move(to: .createManualLedger(id))
    default: break
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension AppCoordinator {
  func sign(animated: Bool) {
    let splashVC = DIContainer.shared.resolve(type: SignFactoryInterface.self).makeSplash()
    navigationController.isNavigationBarHidden = false
    navigationController.viewControllers = [splashVC]
  }
  
  func main(animated: Bool) {
    let mainTabCoordinator = MainTabBarCoordinator(
      navigationController: navigationController
    )
    mainTabCoordinator.start(animated: true)
    mainTabCoordinator.parentCoordinator = self
    childCoordinators.append(mainTabCoordinator)
  }
}
