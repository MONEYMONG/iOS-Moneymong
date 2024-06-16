import UIKit

import BaseFeature
import MainFeature
import SignFeature
import DesignSystem

final class AppCoordinator: Coordinator {
  var navigationController: UINavigationController
  var diContainer: AppDIContainer = AppDIContainer()
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(restartWithAlert),
      name: .appRestart,
      object: nil
    )
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

  @objc func restartWithAlert(_ notification: Notification) {
    let message = notification.userInfo?["message"] as? String

    DispatchQueue.main.async {
      AlertsManager.show(
        title: message ?? "앱을 재실행 합니다.",
        type: .onlyOkButton { [weak self] in
          self?.childCoordinators.forEach { $0.remove() }
          self?.start(animated: false)
        })
    }
  }
}
