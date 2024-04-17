import UIKit

import BaseFeature

public final class MyPageCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: MyPageDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: MyPageDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    myPage(animated: animated)
  }
}

extension MyPageCoordinator {
  private func myPage(animated: Bool) {
    let vc = diContainer.myPage(with: self)
    navigationController.setViewControllers([vc], animated: true)
  }
}
