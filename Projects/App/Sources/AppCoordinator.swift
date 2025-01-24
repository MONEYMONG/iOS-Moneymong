import UIKit

import AgencyFeature
import AgencyFeatureInterface
import BaseFeature
import BaseFeatureInterface
import MainFeature
import SignFeature
import SignFeatureInterface
import DesignSystem
import LedgerFeature
import LedgerFeatureInterface
import MyPageFeature
import MyPageFeatureInterface

final class AppCoordinator: Coordinator {
  var navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(animated: Bool) {
    sign(animated: animated)
  }
  
  func move(to scene: Scene) {
    switch scene {
    case .main:
      main(animated: true)
    case .login:
      sign(animated: true)
    case .ledger:
      main(animated: true)
//      let mainCoordinator = childCoordinators.first { $0 is MainTabBarCoordinator }
//      mainCoordinator?.move(to: .ledger)
    case let .createManualLedger(id):
      main(animated: true)
//      let mainCoordinator = childCoordinators.first { $0 is MainTabBarCoordinator }
//      mainCoordinator?.move(to: .createManualLedger(id))
    default: break
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

extension AppCoordinator {
  func sign(animated: Bool) {
    let splashVC = DIContainer.shared.resolve(type: SignFactoryInterface.self).makeSplash()
    navigationController.isNavigationBarHidden = false
    navigationController.viewControllers = [splashVC]
  }
  
  func main(animated: Bool) {
    let mainTapVC = MainTapViewController()
    mainTapVC.setViewControllers(
      [
        agencyTab(),
        ledgerTab(),
        myPageTab()
      ],
      animated: false
    )
    navigationController.isNavigationBarHidden = true
    navigationController.viewControllers = [mainTapVC]
  }
  
  private func agencyTab() -> UIViewController {
    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let agencyListVC = factory.makeAgencyList()
    return UINavigationController(rootViewController: agencyListVC)
  }
  
  private func ledgerTab() -> UIViewController {
    let ledgerFactory = DIContainer.shared.resolve(type: LedgerFactoryInterface.self)
    let ledgerTab = ledgerFactory.makeLedgerTab()
    let memberTab = ledgerFactory.makeMemberTab(delegate: nil)
    let ledgerMainVC = ledgerFactory.makeLedgerMain(ledgerTab: ledgerTab, memberTab: memberTab)
    return UINavigationController(rootViewController: ledgerMainVC)
  }
  
  private func myPageTab() -> UIViewController {
    let myPageVC = DIContainer.shared.resolve(type: MyPageFactoryInterface.self).makeMyPageVC()
    return UINavigationController(rootViewController: myPageVC)
  }
}
