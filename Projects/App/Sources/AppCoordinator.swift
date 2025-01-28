import UIKit

import BaseFeature
import MainFeature
import SignFeature
import DesignSystem

final class AppCoordinator: Coordinator {
  weak var navigationController: UINavigationController?
  weak var parentCoordinator: Coordinator?
  
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
    case .login:
      sign(animated: true)
    case .ledger:
      main(animated: true) { mainCoordinator in
        mainCoordinator.move(to: .ledger)
      }
    case let .createManualLedger(id):
      main(animated: true) { mainCoordinator in
        mainCoordinator.move(to: .createManualLedger(id))
      }
    default: break
    }
  }
}

extension AppCoordinator {
  func sign(animated: Bool) {
    let signCoordinator = SignCoordinator(
      navigationController: navigationController
    )
    signCoordinator.start(animated: true)
    signCoordinator.parentCoordinator = self
  }
  
  func main(animated: Bool, completion: ((Coordinator) -> Void)? = nil) {
    let mainTabCoordinator = MainTabBarCoordinator(
      navigationController: navigationController
    )
    mainTabCoordinator.start(animated: true)
    mainTabCoordinator.parentCoordinator = self
    completion?(mainTabCoordinator)
  }
}
