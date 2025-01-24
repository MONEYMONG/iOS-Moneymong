import UIKit

import AgencyFeatureInterface
import BaseFeature
import BaseFeatureInterface
import LedgerFeature
import LedgerFeatureInterface
import MyPageFeatureInterface

public final class MainTabBarCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  weak var tabBarController: UITabBarController?

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start(animated: Bool) {
    mainTab(animated: animated)
  }
  
  public func move(to scene: Scene) {
    switch scene {
    case .main: // 메인으로 이동
      debugPrint("move to main")
    case .login: // 로그인으로 이동
      parentCoordinator?.move(to: .login)
      remove()
    case .ledger: // 장부로 이동
      tabBarController?.selectedIndex = 1
    case let .createManualLedger(agencyID): // 장부 이동 &
      tabBarController?.selectedIndex = 1
      NotificationCenter.default.post(name: .presentManualCreater, object: nil, userInfo: ["id": agencyID])
    case let .createOCRLedger(agencyID):
      tabBarController?.selectedIndex = 1
      NotificationCenter.default.post(name: .presentOCRCreater, object: nil, userInfo: ["id": agencyID])
    
    case .agency: // 소속으로 이동
      tabBarController?.selectedIndex = 0
    }
  }
  
  deinit {
    debugPrint(#function)
  }
}

public extension MainTabBarCoordinator {
  func mainTab(animated: Bool) {
    let vc = mainTab(with: self)
    navigationController.isNavigationBarHidden = true
    navigationController.viewControllers = [vc]
    tabBarController = vc
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
