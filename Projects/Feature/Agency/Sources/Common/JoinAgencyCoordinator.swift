import UIKit

import AgencyFeatureInterface
import BaseFeature
import DesignSystem

public final class JoinAgencyCoordinator: JoinAgencyCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  public init() {}
  
  enum Destination {
    case joinComplete
    case alert(title: String)
  }
  
  public func start(agencyId: Int, agencyName: String, animated: Bool) {
    joinAgency(id: agencyId, name: agencyName, animated: animated)
  }
  
  func push(_ destination: Destination, animated: Bool = true) {
    switch destination {
    case .joinComplete:
      joinComplete(animated: animated)
    case .alert:
      break
    }
  }
  
  func present(_ destination: Destination, animated: Bool = true) {
    switch destination {
    case .joinComplete:
      break
    case let .alert(title):
      AlertsManager.show(title: title)
        
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController?.topViewController?.dismiss(animated: animated)
  }
}

private extension JoinAgencyCoordinator {
  private func joinAgency(id: Int, name: String, animated: Bool) {
    let factory = AgencyFactory()
    let vc = factory.makeJoinAgency(agencyID: id, agencyName: name)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: true)
  }
  
  private func joinComplete(animated: Bool) {
    let factory = AgencyFactory()
    let vc = factory.makeJoinComplete()
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
}
