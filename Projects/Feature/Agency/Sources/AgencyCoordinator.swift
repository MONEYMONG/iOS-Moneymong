import UIKit

import BaseFeatureInterface
import DesignSystem
import CreateAgencyInterface

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
    case createAgency(UniversityType)
    case web(String)
  }

  public func start(animated: Bool) {
    agency(animated: animated)
  }
  
  public func move(to scene: BaseFeatureInterface.Scene) {
    switch scene {
    case .ledger:
      parentCoordinator?.move(to: .ledger)
    case .createManualLedger(let int):
      parentCoordinator?.move(to: .createManualLedger(int))
    default: break
    }
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
    case let .createAgency(universityType):
      createAgency(universityType: universityType, animated: animated)
    case let .web(url):
      web(urlString: url)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController.topViewController?.dismiss(animated: animated)
  }
  
  public func goLedger() {
    parentCoordinator?.move(to: .ledger)
  }
}

extension AgencyCoordinator {
  private func agency(animated: Bool) {
    let vc = diContainer.agency(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func createAgency(universityType: UniversityType, animated: Bool) {
    let vc = diContainer.createAgency(with: self, universityType: universityType)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
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
