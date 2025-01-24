import UIKit

import DesignSystem
import BaseFeature
import BaseFeatureInterface
import AgencyInterface
import LedgerInterface
import LedgerFeatureInterface

public final class LedgerCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  var moveTab: ((Int) -> Void)?
  
  enum Scene {
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
          let memberTabVC = ledgerFactory.makeMemberTab(delegate: nil) as? MemberTabVC else { return }
    
          
    guard let ledgerMainVC = ledgerFactory.makeLedgerMain(ledgerTab: ledgerTabVC, memberTab: memberTabVC) as? LedgerVC else { return }
    ledgerMainVC.coordinator = self
    navigationController.viewControllers = [ledgerMainVC]
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: ManualPresentType,
    animated: Bool
  ) {
    
    let createManualLedgerVC = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeCreateManual(agencyId: agencyId, type: type)
    let navigationController = UINavigationController(rootViewController: createManualLedgerVC)
    navigationController.modalPresentationStyle = .fullScreen
    self.navigationController.present(navigationController, animated: animated)
  }
  
  private func createOCRLedger(agencyId: Int, animated: Bool) {
    let createOCRLedgerVC = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeOCR(agencyId: agencyId)
    let navigationController = UINavigationController(rootViewController: createOCRLedgerVC)
    navigationController.modalPresentationStyle = .fullScreen
    self.navigationController.present(navigationController, animated: animated)
  }

  private func detail(ledgerID: Int, role: Member.Role, animated: Bool = true) {
    guard let vc = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeDetail(ledgetID: ledgerID, role: role) as? LedgerDetailVC else { return }
    navigationController.pushViewController(vc, animated: animated)
  }
}
