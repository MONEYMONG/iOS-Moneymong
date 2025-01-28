import UIKit

import AgencyFeatureInterface
import BaseFeature
import DesignSystem

public final class AgencyCoordinator: AgencyCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  public init() { }
  
  enum Scene {
    case alert(title: String, subTitle: String?, okAction: () -> Void, cancelAction: (() -> Void)? = nil)
    case createAgency(UniversityType)
    case joinAgency(agencyID: Int, agencyName: String)
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
    case let .createAgency(universityType):
      createAgency(universityType: universityType, animated: animated)
    case let .joinAgency(id, name):
      joinAgency(id, name, animated: animated)
    case let .web(url):
      web(urlString: url)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController?.topViewController?.dismiss(animated: animated)
  }
}

extension AgencyCoordinator {
  private func agency(animated: Bool) {
    let factory = AgencyFactory()
    let vc = factory.makeAgencyList()
    vc.coordinator = self
    navigationController?.viewControllers = [vc]
  }
  
  private func createAgency(universityType: UniversityType, animated: Bool) {
    let root = UINavigationController()
    root.modalPresentationStyle = .fullScreen
    
    let coordinator = CreateAgencyCoordinator()
    coordinator.navigationController = root
    coordinator.parentCoordinator = self
    coordinator.start(universityType: universityType, animated: animated)
  
    navigationController?.present(root, animated: animated)
  }
  
  private func joinAgency(_ id: Int, _ name: String, animated: Bool) {
    let vc = UINavigationController()
    vc.modalPresentationStyle = .fullScreen
    
    let coordinator = JoinAgencyCoordinator(navigationController: vc)
    coordinator.parentCoordinator = self
    coordinator.start(agencyId: id, agencyName: name, animated: animated)
    
    navigationController?.present(vc, animated: animated)
  }
}
