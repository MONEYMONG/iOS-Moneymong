import UIKit

import AgencyFeatureInterface
import BaseFeature

public final class AgencyCoordinator: AgencyCoordinatorInterface {
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

fileprivate extension AgencyCoordinator {
  func main(animated: Bool) {
    let viewController = AgencyViewController()
    navigationController.pushViewController(viewController, animated: animated)
  }
}
