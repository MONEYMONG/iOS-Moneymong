import UIKit

import BaseFeature

final class ChildLedgerCoordinator: Coordinator {
  var navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  private let diContainer: ChildLedgerDIContainer

  init(
    navigationController: UINavigationController,
    diContainer: ChildLedgerDIContainer
  ) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }
  
  func start(animated: Bool) {
    childLedger(animated: false)
  }
}

extension ChildLedgerCoordinator {
  private func childLedger(animated: Bool) {
    let vc = diContainer.childLedger(with: self)
    navigationController.title = "장부"
    navigationController.viewControllers = [vc]
  }
}
