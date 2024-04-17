import UIKit
import BaseFeature

import AgencyFeature
import LedgerFeature
import MyPageFeature

public final class MainDIContainer {
  private let agencyContainer: AgencyDIContainer
  private let myPageContainer: MyPageDIContainer
  private let ledgerContainer: LedgerDIContainer

  public init(
    agencyContainer: AgencyDIContainer,
    myPageContainer: MyPageDIContainer,
    ledgerContainer: LedgerDIContainer
  ) {
    self.agencyContainer = agencyContainer
    self.myPageContainer = myPageContainer
    self.ledgerContainer = ledgerContainer
  }

  func mainTab(with coordinator: Coordinator) -> MainTapViewController {
    let tabVC = MainTapViewController()
    tabVC.setViewControllers(
      [agencyTab(with: coordinator),
       ledgerTab(with: coordinator),
       myPageTab(with: coordinator)],
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
  
  private func ledgerTab(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let ledgerCoordinator = LedgerCoordinator(
      navigationController: vc,
      diContainer: ledgerContainer
    )
    coordinator.childCoordinators.append(ledgerCoordinator)
    ledgerCoordinator.parentCoordinator = coordinator
    ledgerCoordinator.start(animated: false)
    return vc
  }
  
  private func myPageTab(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let myPageCoordinator = MyPageCoordinator(
      navigationController: vc,
      diContainer: myPageContainer
    )
    coordinator.childCoordinators.append(myPageCoordinator)
    myPageCoordinator.parentCoordinator = coordinator
    myPageCoordinator.start(animated: false)
    return vc
  }
}
