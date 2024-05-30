import UIKit

import BaseFeature
import LedgerFeature

public final class MainTabBarCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: MainDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  weak var tabBarController: UITabBarController?

  public init(navigationController: UINavigationController, diContainer: MainDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    mainTab(animated: animated)
  }
  
  public func move(to scene: Scene) {
    switch scene {
    case .main: // 메인으로 이동
      print("move to main")
    case .login: // 로그인으로 이동
      parentCoordinator?.move(to: .login)
      remove()
    case .ledger: // 장부로 이동
      tabBarController?.selectedIndex = 1
    case let .manualInput(agencyID): // 장부 이동 &
      tabBarController?.selectedIndex = 1
      NotificationCenter.default.post(name: .presentManualInput, object: nil, userInfo: ["id": agencyID])
    case .agency: // 소속으로 이동
      tabBarController?.selectedIndex = 0
    }
  }
  
  deinit {
    print(#function)
  }
}

public extension MainTabBarCoordinator {
  func mainTab(animated: Bool) {
    let vc = diContainer.mainTab(with: self)
    navigationController.isNavigationBarHidden = true
    navigationController.viewControllers = [vc]
    tabBarController = vc
  }
}
