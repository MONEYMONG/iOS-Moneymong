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
    case alert(title: String, subTitle: String?, okAction: () -> Void, cancelAction: (() -> Void)? = nil)
    case joinAgency(id: Int, name: String)
    case joinComplete
    case createAgency
    case createComplete(id: Int)
  }

  public func start(animated: Bool) {
    agency(animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, okAction, cancelAction):
      if let cancelAction {
        AlertsManager.show(title: title, subTitle: subTitle, type: .default(okAction: okAction, cancelAction: cancelAction))
      } else {
        AlertsManager.show(title: title, subTitle: subTitle, type: .onlyOkButton(okAction))
      }
    case let .joinAgency(id, name): 
      joinAgency(id: id, name: name, animated: animated)
    case .joinComplete:
      joinComplete(animated: animated)
    case .createAgency: 
      createAgency(animated: animated)
    case let .createComplete(id):
      createComplete(agencyID: id, animated: animated)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController.topViewController?.dismiss(animated: animated)
  }
  
  func goLedger() {
    parentCoordinator?.move(to: .ledger)
  }
  
  func goManualInput(agencyID: Int) {
    parentCoordinator?.move(to: .createManualLedger(agencyID))
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
  
  private func createComplete(agencyID: Int, animated: Bool) {
    let vc = diContainer.createComplete(with: self, id: agencyID)
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
