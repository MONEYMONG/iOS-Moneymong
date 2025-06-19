import UIKit

import AgencyFeatureInterface
import BaseFeature
import DesignSystem
import LedgerFeatureInterface

public final class JoinAgencyCoordinator: JoinAgencyCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  private let ledgerService: LedgerServiceInterface?
  
  public init(ledgerService: LedgerServiceInterface?) {
    self.ledgerService = ledgerService
  }
  
  enum Destination {
    case alert(title: String)
  }
  
  public func start(animated: Bool) {
    joinAgency(animated: animated)
  }
  
  func present(_ destination: Destination, animated: Bool = true) {
    switch destination {
    case let .alert(title):
      AlertsManager.show(title: title)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController?.topViewController?.dismiss(animated: animated)
  }
}

private extension JoinAgencyCoordinator {
  private func joinAgency(animated: Bool) {
    let vc = AgencyFactory().makeJoinAgency(ledgerService: ledgerService)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
}
