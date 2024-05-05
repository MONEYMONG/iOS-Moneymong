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
    case joinAgency
    case createAgency
  }

  public func start(animated: Bool) {
    agency(animated: animated)
  }
  
  func push(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .alert: break
    case .joinAgency: break
    case .createAgency: break
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, okAction):
      AlertsManager.show(navigationController, title: title, subTitle: subTitle, okAction: okAction, cancelAction: nil)
    case .joinAgency: break
    case .createAgency:
      createAgency(animated: animated)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController.topViewController?.dismiss(animated: animated)
  }
}

extension AgencyCoordinator {
  private func agency(animated: Bool) {
    let vc = diContainer.agency(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func createAgency(animated: Bool) {
    let vc = diContainer.createAgency(with: self)
    let rootVC = UINavigationController(rootViewController: vc)
    rootVC.modalPresentationStyle = .fullScreen
    navigationController.topViewController?.present(rootVC, animated: animated)
  }
}
