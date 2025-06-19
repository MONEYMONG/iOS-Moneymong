import UIKit

import BaseFeature
import LedgerFeatureInterface
import MyPageFeatureInterface

public final class MainTabBarCoordinator: Coordinator {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  weak var tabBarController: UITabBarController?

  public init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  public func start(animated: Bool) {
    mainTab(animated: animated)
  }
  
  public func move(to scene: Scene) {
    switch scene {
    case .main: // 메인으로 이동
      break
    case .login: // 로그인으로 이동
      parentCoordinator?.move(to: .login)
    case .ledger: // 장부로 이동
      tabBarController?.selectedIndex = 0
    case let .createManualLedger(agencyID): // 장부 이동 &
      tabBarController?.selectedIndex = 0
      NotificationCenter.default.post(name: .presentManualCreater, object: nil, userInfo: ["id": agencyID])
    case .createAgency:
      tabBarController?.selectedIndex = 0
      NotificationCenter.default.post(name: .presentAgencyCreater, object: nil, userInfo: nil)
    }
  }
}

public extension MainTabBarCoordinator {
  private func mainTab(animated: Bool) {
    let tabVC = MainTapViewController()
    tabVC.coordinator = self
    tabVC.setViewControllers(
      [ledgerTab(),
       myPageTab()],
      animated: false
    )
    navigationController?.isNavigationBarHidden = true
    navigationController?.viewControllers = [tabVC]
    tabBarController = tabVC
  }
  
  private func ledgerTab() -> UIViewController {
    let navigationC = UINavigationController()
    let ledgerCoordinator = DIContainer.shared.resolve(type: LedgerCoordinatorInterface.self)
    ledgerCoordinator.navigationController = navigationC
    ledgerCoordinator.parentCoordinator = self
    ledgerCoordinator.start(animated: false)
    return navigationC
  }
  
  private func myPageTab() -> UIViewController {
    let navigationC = UINavigationController()
    let myPageCoordinator = DIContainer.shared.resolve(type: MyPageCoordinatorInterface.self)
    myPageCoordinator.navigationController = navigationC
    myPageCoordinator.parentCoordinator = self
    myPageCoordinator.start(animated: false)
    return navigationC
  }
}
