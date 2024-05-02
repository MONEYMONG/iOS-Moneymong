import UIKit

import BaseFeature
import DesignSystem

public final class AgencyCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: AgencyDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: AgencyDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }
  
  enum Scene {
    case alert(title: String, subTitle: String, okAction: () -> Void)
    case joinMember
    case createMember
  }

  public func start(animated: Bool) {
    agency(animated: animated)
  }
  
  func push(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .alert: break
    case .joinMember: break
    case .createMember: break
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, okAction):
      AlertsManager.show(navigationController, title: title, subTitle: subTitle, okAction: okAction, cancelAction: nil)
    case .joinMember: break
    case .createMember: break
    }
  }
}

extension AgencyCoordinator {
  private func agency(animated: Bool) {
    let vc = diContainer.agency(with: self)
    navigationController.viewControllers = [vc]
  }
}
