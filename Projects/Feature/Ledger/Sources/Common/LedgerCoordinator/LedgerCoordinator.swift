import UIKit

import DesignSystem
import BaseFeature
import AgencyInterface
import LedgerInterface
import LedgerFeatureInterface

public final class LedgerCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  var moveTab: ((Int) -> Void)?
  
  enum Scene {
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case createManualLedger(Int, ManualPresentType)
    case createOCRLedger(Int)
    case detail(Ledger, Member.Role)
  }

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func start(animated: Bool) {
    ledger(animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .createManualLedger(agencyId, type):
      createManualLedger(agencyId: agencyId, type: type, animated: animated)
    case let .alert(title, subTitle, type):
      AlertsManager.show(title: title, subTitle: subTitle, type: type)
    case let .createOCRLedger(id):
      createOCRLedger(agencyId: id, animated: animated)
    case let .detail(ledger, role):
      detail(ledgerID: ledger.id, role: role)
    }
  }
  
  func goAgency() {
    parentCoordinator?.move(to: .agency)
  }

  func pop(animated: Bool = true) {
    navigationController.popViewController(animated: animated)
  }
}

extension LedgerCoordinator {
  
  private func ledger(animated: Bool) {
    let ledgerFactory = DIContainer.shared.resolve(type: LedgerFactoryInterface.self)
    
    guard let ledgerTabVC = ledgerFactory.makeLedgerTab() as? LedgerTabVC,
          let memberTabVC = ledgerFactory.makeMemberTab() as? MemberTabVC else { return }
    
    ledgerTabVC.coordinator = self
    memberTabVC.coordinator = self
          
    guard let ledgerMainVC = ledgerFactory.makeLedgerMain(ledgerTab: ledgerTabVC, memberTab: memberTabVC) as? LedgerVC else { return }
    ledgerMainVC.coordinator = self
    navigationController.viewControllers = [ledgerMainVC]
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: ManualPresentType,
    animated: Bool
  ) {
    let navigationController = UINavigationController()
    let coordinator = CreateManualLedgerCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    parentCoordinator?.childCoordinators.append(coordinator)
    navigationController.modalPresentationStyle = .fullScreen
    coordinator.start(agencyId: agencyId, type: type, animated: false)
    self.navigationController.present(navigationController, animated: animated)
  }
  
  private func createOCRLedger(agencyId: Int, animated: Bool) {
    let navigationController = UINavigationController()
    let coordinator = CreateOCRLedgerCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    parentCoordinator?.childCoordinators.append(coordinator)
    navigationController.modalPresentationStyle = .fullScreen
    coordinator.start(agencyId: agencyId, animated: animated)
    self.navigationController.present(navigationController, animated: animated)
  }

  private func detail(ledgerID: Int, role: Member.Role, animated: Bool = true) {
    guard let vc = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeDetail(ledgetID: ledgerID, role: role) as? LedgerDetailVC else { return }
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: animated)
  }
}
