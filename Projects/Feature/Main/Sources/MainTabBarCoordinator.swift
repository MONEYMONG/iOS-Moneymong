import UIKit

import BaseFeature

public final class MainTabBarCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: MainDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []

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
      print("main")
      break
    case .login:
      parentCoordinator?.move(to: .login)
      remove()
    }
  }
  
  deinit {
    print(#function)
  }
}

public extension MainTabBarCoordinator {
  func mainTab(animated: Bool) {
    let vc = diContainer.mainTab(with: self)
    navigationController.viewControllers = [vc]
  }
}
