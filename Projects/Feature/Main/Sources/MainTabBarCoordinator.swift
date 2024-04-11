import UIKit

import MainFeatureInterface
import BaseFeature

public final class MainTabBarCoordinator: MainTabBarCoordinatorInterface {
  public var navigationController: UINavigationController
  public var diContainer: BaseFeature.DIContainerInterface
  public weak var parentCoordinator: (BaseFeature.Coordinator)?
  public var childCoordinators: [BaseFeature.Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: DIContainerInterface) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    main(animated: animated)
  }
}

public extension MainTabBarCoordinator {
  func main(animated: Bool) {
    let viewController = MainTapViewController()
    navigationController.pushViewController(viewController, animated: animated)
  }
}
