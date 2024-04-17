import UIKit

import BaseFeature

public final class SignCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: SignDIContainer
  public weak var parentCoordinator: (BaseFeature.Coordinator)?
  public var childCoordinators: [BaseFeature.Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: SignDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    splash()
  }
}

public extension SignCoordinator {
  func splash(animated: Bool = false) {
    let vc = diContainer.splash(with: self)
    navigationController.pushViewController(vc, animated: true)
  }

  func login(animated: Bool = true) {
    let vc = diContainer.login(with: self)
    navigationController.pushViewController(vc, animated: animated)
  }

  func main() {
    parentCoordinator?.move(to: .main)
    remove()
  }
}
