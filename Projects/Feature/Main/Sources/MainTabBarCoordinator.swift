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
    case .main:
      print("move to main")
    case .login:
      parentCoordinator?.move(to: .login)
      remove()
    case .ledger:
      tabBarController?.selectedIndex = 0
    case let .manualCreater(agencyID):
      tabBarController?.selectedIndex = 0
      NotificationCenter.default.post(name: .presentManualCreater, object: nil, userInfo: ["id": agencyID])
    case .agency:
      tabBarController?.selectedIndex = 1
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
