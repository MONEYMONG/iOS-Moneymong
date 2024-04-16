import UIKit
import BaseFeature

import AgencyFeature
import LedgerFeature
import MyPageFeature

public final class MainDIContainer {
  private let agencyContainer: AgencyDIContainer

  public init(agencyContainer: AgencyDIContainer) {
    self.agencyContainer = agencyContainer
  }

  func mainTab(with coordinator: Coordinator) -> MainTapViewController {
    let tabVC = MainTapViewController()
    tabVC.setViewControllers(
      [agencyTab(with: coordinator)],
      animated: false
    )
    return tabVC
  }

  private func agencyTab(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let agencyCoordinator = AgencyCoordinator(
      navigationController: vc,
      diContainer: agencyContainer
    )
    coordinator.childCoordinators.append(agencyCoordinator)
    agencyCoordinator.parentCoordinator = coordinator
    agencyCoordinator.start(animated: false)
    return vc
  }
}
