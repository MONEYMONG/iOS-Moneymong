import UIKit

import DesignSystem
import BaseFeature
import AgencyFeatureInterface

public final class AgencyCoordinator: Coordinator {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  weak var secondFlowNavigationController: UINavigationController?
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
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
    navigationController?.topViewController?.dismiss(animated: animated)
  }
  
  public func goLedger() {
    parentCoordinator?.move(to: .ledger)
  }
}

extension AgencyCoordinator {
  private func agency(animated: Bool) {
#warning("TODO")
//    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
//    let vc = factory.makeAgencyList()
//    if let agencyList = vc as? AgencyListVC {
//      agencyList.coordinator = self
//    }
    navigationController?.viewControllers = [UIViewController()]
  }
  
  private func createAgency(universityType: UniversityType, animated: Bool) {
    let vc = UINavigationController()
    let coordinator = CreateAgencyCoordinator(navigationController: vc)
    coordinator.parentCoordinator = self
    coordinator.start(animated: animated, universityType: universityType)
    vc.modalPresentationStyle = .fullScreen
    navigationController?.present(vc, animated: animated)
  }
  
  private func joinAgency(id: Int, name: String, animated: Bool) {
    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let vc = factory.makeJoinAgency(agencyID: id, agencyName: name)
    
    secondFlowNavigationController = vc as? UINavigationController
    vc.modalPresentationStyle = .fullScreen
    navigationController?.topViewController?.present(vc, animated: animated)
  }
  
  private func joinComplete(animated: Bool) {
    let factory = DIContainer.shared.resolve(type: AgencyFactoryInterface.self)
    let vc = factory.makeJoinComplete()
    secondFlowNavigationController?.pushViewController(vc, animated: animated)
  }
}
