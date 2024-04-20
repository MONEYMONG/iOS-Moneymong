import UIKit

import BaseFeature

public final class LedgerDIContainer {
  public init() {}
  
  func ledger(with coordinator: Coordinator) -> LedgerVC {
    let vc = LedgerVC(
      [
        childLeger(with: coordinator),
        childMember(with: coordinator)
      ]
    )
    vc.reactor = LedgerReactor()
    vc.coordinator = coordinator
    return vc
  }
  
  private func childLeger(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let childLedgerCoordinator = ChildLedgerCoordinator(
      navigationController: vc,
      diContainer: ChildLedgerDIContainer()
    )
    coordinator.childCoordinators.append(childLedgerCoordinator)
    childLedgerCoordinator.start(animated: false)
    return vc
  }
  
  private func childMember(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let childMemberCoordinator = ChildMemberCoordinator(
      navigationController: vc,
      diContainer: ChildMemberDIContainer()
    )
    coordinator.childCoordinators.append(childMemberCoordinator)
    childMemberCoordinator.parentCoordinator = coordinator
    childMemberCoordinator.start(animated: false)
    return vc
  }
}
