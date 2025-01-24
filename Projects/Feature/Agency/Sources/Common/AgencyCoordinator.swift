import UIKit

import DesignSystem

import BaseFeature
import BaseFeatureInterface

import AgencyFeatureInterface
import CreateAgencyInterface

public final class AgencyCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  weak var secondFlowNavigationController: UINavigationController?
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  enum Scene {
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
    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let vc = factory.makeAgencyList()
    if let agencyList = vc as? AgencyListVC {
      agencyList.coordinator = self
    }
    navigationController.viewControllers = [vc]
  }
  
  private func createAgency(universityType: UniversityType, animated: Bool) {
    
    let inputAgencyInfoVC = DIContainer.shared.resolve(type: InputAgencyInfoFactoryInterface.self).make(universityType: universityType)
    let navigationC = UINavigationController()
    navigationC.viewControllers = [inputAgencyInfoVC]
    navigationC.modalPresentationStyle = .fullScreen
    navigationController.present(navigationC, animated: animated)
  }
  
  private func joinAgency(id: Int, name: String, animated: Bool) {
    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let vc = factory.makeJoinAgency(agencyID: id, agencyName: name)
    
    secondFlowNavigationController = vc as? UINavigationController
    vc.modalPresentationStyle = .fullScreen
    navigationController.topViewController?.present(vc, animated: animated)
  }
  
  private func joinComplete(animated: Bool) {
    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let vc = factory.makeJoinComplete()
    secondFlowNavigationController?.pushViewController(vc, animated: animated)
  }
}
