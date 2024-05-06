import UIKit

import BaseFeature
import DesignSystem

public final class AgencyCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: AgencyDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  weak var secondFlowNavigationController: UINavigationController?

  public init(navigationController: UINavigationController, diContainer: AgencyDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }
  
  enum Scene {
    case alert(title: String, subTitle: String, okAction: () -> Void)
    case joinAgency
    case createAgency
    case createComplete
  }

  public func start(animated: Bool) {
    agency(animated: animated)
  }
  
  func push(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .alert: break
    case .joinAgency: break
    case .createAgency: break
    case .createComplete:
      createCompleteAgency(animated: true)
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, okAction):
      AlertsManager.show(
        title: title,
        subTitle: subTitle,
        okAction: okAction,
        cancelAction: nil
      )
    case .joinAgency: break
    case .createAgency:
      createAgency(animated: animated)
    case .createComplete: break
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController.topViewController?.dismiss(animated: animated)
  }
  
  func goLedger() {
    // TODO: 상위코디네이터랑 연결!
    print("GoLedger")
  }
  
  func goCreateLedger() {
    // TODO: 상위코디네이터랑 연결!
    print("Go Create Ledger")
  }
}

extension AgencyCoordinator {
  private func agency(animated: Bool) {
    let vc = diContainer.agency(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func createAgency(animated: Bool) {
    let vc = diContainer.createAgency(with: self)
    secondFlowNavigationController = vc as? UINavigationController
    vc.modalPresentationStyle = .fullScreen
    navigationController.topViewController?.present(vc, animated: animated)
  }
  
  private func createCompleteAgency(animated: Bool) {
    let vc = diContainer.createCompleteAgency(with: self)
    secondFlowNavigationController?.pushViewController(vc, animated: animated)
  }
}
