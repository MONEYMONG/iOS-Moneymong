import UIKit

import DesignSystem
import BaseFeature
import AgencyInterface
import LedgerInterface
import LedgerFeatureInterface

public final class LedgerCoordinator: LedgerCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  var moveTab: ((Int) -> Void)?
  
  private let ledgerService: LedgerServiceInterface
  private let contentFormatter: ContentFormatter
  
  enum Scene {
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case createManualLedger(Int, ManualPresentType)
    case createOCRLedger(Int)
    case detail(Ledger, Member.Role)
  }

  public init(ledgerService: LedgerServiceInterface, contentFormatter: ContentFormatter) {
    self.ledgerService = ledgerService
    self.contentFormatter = contentFormatter
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
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}

extension LedgerCoordinator {
  private func ledger(animated: Bool) {
    let ledgerFactory = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter)
    
    let ledgerTabVC = ledgerFactory.makeLedgerTab()
    let memberTabVC = ledgerFactory.makeMemberTab()
    ledgerTabVC.coordinator = self
    memberTabVC.coordinator = self
          
    let ledgerMainVC = ledgerFactory.makeLedgerMain(ledgerTab: ledgerTabVC, memberTab: memberTabVC)
    ledgerMainVC.coordinator = self
    navigationController?.viewControllers = [ledgerMainVC]
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: ManualPresentType,
    animated: Bool
  ) {
    let navigationController = UINavigationController()
    let coordinator = DIContainer.shared.resolve(type: CreateManualLedgerCoordinatorInterface.self)
    coordinator.navigationController = navigationController
    coordinator.parentCoordinator = self
    navigationController.modalPresentationStyle = .fullScreen
    coordinator.start(agencyId: agencyId, type: type, animated: false)
    self.navigationController?.present(navigationController, animated: animated)
  }
  
  private func createOCRLedger(agencyId: Int, animated: Bool) {
    let navigationController = UINavigationController()
    let coordinator = DIContainer.shared.resolve(type: CreateOCRLedgerCoordinatorInterface.self)
    coordinator.navigationController = navigationController
    coordinator.parentCoordinator = self
    navigationController.modalPresentationStyle = .fullScreen
    coordinator.start(agencyId: agencyId, animated: animated)
    self.navigationController?.present(navigationController, animated: animated)
  }

  private func detail(ledgerID: Int, role: Member.Role, animated: Bool = true) {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeDetail(ledgetID: ledgerID, role: role)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func editMember(agencyID: Int, member: Member) {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeEditMember(agencyID: agencyID, member: member)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    navigationController?.present(vc, animated: false)
  }
  
  func selectAgencySheet() {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeSelectAgency()
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    navigationController?.present(vc, animated: false)
  }
  
  func datePicker(start: DateInfo, end: DateInfo) {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeDatePicker(start: start, end: end)
    vc.modalPresentationStyle = .overFullScreen
    navigationController?.present(vc, animated: false)
  }
}
