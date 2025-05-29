import UIKit

import AgencyFeatureInterface
import BaseFeature

public final class CreateAgencyCoordinator: CreateAgencyCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  public init() { }

  public func start(animated: Bool) {
    inputAgencyInfo(animated: animated)
  }
  
  func dismiss(animated: Bool = true) {
    navigationController?.topViewController?.dismiss(animated: animated)
  }
}

private extension CreateAgencyCoordinator {
  func inputAgencyInfo(animated: Bool) {
    let vc = AgencyFactory().makeInputAgencyInfo()
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
}
