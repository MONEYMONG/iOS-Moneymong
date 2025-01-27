import UIKit

import AgencyFeature
import BaseFeature
import Core
import AgencyFeatureInterface
import LedgerFeature
import MyPageFeatureInterface


public final class MainDIContainer {
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae
    
  public init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
  }

  func mainTab(with coordinator: Coordinator) -> MainTapViewController {
    let tabVC = MainTapViewController()
    tabVC.coordinator = coordinator
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
    let agencyCoordinator = AgencyCoordinator(navigationController: vc)
    agencyCoordinator.parentCoordinator = coordinator
    agencyCoordinator.start(animated: false)
    return vc
  }
  
  private func ledgerTab(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let ledgerCoordinator = LedgerCoordinator(navigationController: vc)
    ledgerCoordinator.parentCoordinator = coordinator
    ledgerCoordinator.start(animated: false)
    return vc
  }
  
  private func myPageTab(with coordinator: Coordinator) -> UIViewController {
    let navigationC = UINavigationController()
    let myPageCoordinator = DIContainer.shared.resolve(type: MyPageCoordinatorInterface.self)
    myPageCoordinator.navigationController = navigationC
    myPageCoordinator.parentCoordinator = coordinator
    myPageCoordinator.start(animated: false)
    return navigationC
  }
}
