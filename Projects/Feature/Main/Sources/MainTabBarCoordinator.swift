import UIKit

import BaseFeature

public final class MainTabBarCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: MainDIContainer
  public weak var parentCoordinator: (BaseFeature.Coordinator)?
  public var childCoordinators: [BaseFeature.Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: MainDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    mainTab(animated: animated)
  }
}

public extension MainTabBarCoordinator {
  func mainTab(animated: Bool) {
    let vc = diContainer.mainTab(with: self)
    navigationController.viewControllers = [vc]
  }
}
