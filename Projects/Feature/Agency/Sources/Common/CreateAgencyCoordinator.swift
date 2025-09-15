import UIKit

import AgencyFeatureInterface
import BaseFeature
import LedgerFeatureInterface

public final class CreateAgencyCoordinator: CreateAgencyCoordinatorInterface {
  enum Scene {
    case code
  }
  
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  private let ledgerService: LedgerServiceInterface?
  
  public init(ledgerService: LedgerServiceInterface?) {
    self.ledgerService = ledgerService
  }

  public func start(animated: Bool) {
    inputAgencyInfo(animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .code:
      joinAgnecy(animated: animated)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController?.topViewController?.dismiss(animated: animated)
  }
}

private extension CreateAgencyCoordinator {
  func inputAgencyInfo(animated: Bool) {
    let vc = AgencyFactory().makeInputAgencyInfo(ledgerService: ledgerService)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func joinAgnecy(animated: Bool) {
    let vc = AgencyFactory().makeJoinAgency(navigationType: .push, ledgerService: ledgerService)
    vc.coordinator = JoinAgencyCoordinator(ledgerService: ledgerService)
    vc.coordinator?.parentCoordinator = self
    vc.coordinator?.navigationController = self.navigationController
    navigationController?.pushViewController(vc, animated: animated)
  }
}
