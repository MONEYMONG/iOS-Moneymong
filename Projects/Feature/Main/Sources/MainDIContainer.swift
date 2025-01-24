import UIKit

import AgencyFeature
import AgencyFeatureInterface
import BaseFeature
import BaseFeatureInterface
import Core
import CreateAgencyInterface
import LedgerFeature
import MyPageFeature
import MyPageFeatureInterface
import LedgerFeatureInterface


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
    let navigationC = UINavigationController()

    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let agencyListVC = factory.makeAgencyList()
    navigationC.viewControllers = [agencyListVC]
    return navigationC
  }
  
  private func ledgerTab(with coordinator: Coordinator) -> UIViewController {
    let ledgerFactory = DIContainer.shared.resolve(type: LedgerFactoryInterface.self)
    let ledgerTab = ledgerFactory.makeLedgerTab()
    let memberTab = ledgerFactory.makeMemberTab(delegate: nil)
    let ledgerMainVC = ledgerFactory.makeLedgerMain(ledgerTab: ledgerTab, memberTab: memberTab)
    return UINavigationController(rootViewController: ledgerMainVC)
  }
  
  private func myPageTab(with coordinator: Coordinator) -> UIViewController {
    let navigationC = UINavigationController()
    let myPageVC = DIContainer.shared.resolve(type: MyPageFactoryInterface.self).makeMyPageVC()
    navigationC.viewControllers = [myPageVC]
    return navigationC
  }
}
