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
    case alert(title: String, subTitle: String?, okAction: () -> Void)
    case joinAgency(id: Int, name: String)
    case joinComplete
    case createAgency
    case createComplete
  }

  public func start(animated: Bool) {
    agency(animated: animated)
  }
  
  func push(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .createComplete: createComplete(animated: animated)
    case .joinComplete: joinComplete(animated: animated)
    default: break
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, okAction):
      AlertsManager.show(title: title, subTitle: subTitle, type: .onlyOkButton(okAction))
    case let .joinAgency(id, name): joinAgency(id: id, name: name, animated: animated)
    case .createAgency: createAgency(animated: animated)
    default: break
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
  
  private func createComplete(animated: Bool) {
    let vc = diContainer.createComplete(with: self)
    secondFlowNavigationController?.pushViewController(vc, animated: animated)
  }
  
  private func joinAgency(id: Int, name: String, animated: Bool) {
    let vc = diContainer.joinAgency(id: id, name: name, with: self)
    secondFlowNavigationController = vc as? UINavigationController
    vc.modalPresentationStyle = .fullScreen
    navigationController.topViewController?.present(vc, animated: animated)
  }
  
  private func joinComplete(animated: Bool) {
    let vc = diContainer.joinComplete(with: self)
    secondFlowNavigationController?.pushViewController(vc, animated: animated)
  }
}
