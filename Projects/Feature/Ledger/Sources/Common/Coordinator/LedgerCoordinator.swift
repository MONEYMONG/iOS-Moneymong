import UIKit

import AgencyInterface
import AgencyFeatureInterface
import BaseDomain
import BaseFeature
import DesignSystem
import LedgerInterface
import LedgerFeatureInterface

public final class LedgerCoordinator: LedgerCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  var moveTab: ((Int) -> Void)?
  
  private let contentFormatter: ContentFormatter
  
  enum Scene {
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case createManualLedger(Int, ManualPresentType)
    case detail(Int, Ledger, Member.Role)
    case createAgency
    case categorySheet(agencyID: Int, categories: [MMCategory])
    case report(agencyID: Int)
  }

  public init(contentFormatter: ContentFormatter) {
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
    case let .detail(agencyID, ledger, role):
      detail(agencyID: agencyID, ledgerID: ledger.id, role: role)
    case .createAgency:
      createAgency()
    case let .categorySheet(agencyID, categories):
      categorySheet(agencyId: agencyID, categories: categories)
    case .report(agencyID: let agencyID):
      report(agencyID: agencyID)
    }
  }
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}

extension LedgerCoordinator {
  private func ledger(animated: Bool) {
    let ledgerFactory = LedgerFactory(contentFormatter: contentFormatter)
    
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

  private func detail(agencyID: Int, ledgerID: Int, role: Member.Role, animated: Bool = true) {
    let vc = LedgerFactory(contentFormatter: contentFormatter).makeDetail(
      agencyID: agencyID,
      ledgetID: ledgerID,
      role: role
    )
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func editMember(agencyID: Int, member: Member) {
    let vc = LedgerFactory(contentFormatter: contentFormatter).makeEditMember(agencyID: agencyID, member: member)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    navigationController?.present(vc, animated: false)
  }
  
  func selectAgencySheet() {
    let vc = LedgerFactory(contentFormatter: contentFormatter).makeSelectAgency()
    vc.coordinator = self
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    navigationController?.present(vc, animated: false)
  }
  
  func datePicker(start: DateInfo, end: DateInfo) {
    let vc = LedgerFactory(contentFormatter: contentFormatter).makeDatePicker(start: start, end: end)
    vc.modalPresentationStyle = .overFullScreen
    navigationController?.present(vc, animated: false)
  }
  
  func createAgency() {
    let navigationController = UINavigationController()
    let coordinator = DIContainer.shared.resolve(type: CreateAgencyCoordinatorInterface.self)
    coordinator.parentCoordinator = self
    coordinator.navigationController = navigationController
    coordinator.start(animated: false)
    navigationController.modalPresentationStyle = .overFullScreen
    self.navigationController?.present(navigationController, animated: true)
  }
  
  func joinAgency() {
    let navigationController = UINavigationController()
    let coordinator = DIContainer.shared.resolve(type: JoinAgencyCoordinatorInterface.self)
    coordinator.parentCoordinator = self
    coordinator.navigationController = navigationController
    coordinator.start(animated: false)
    navigationController.modalPresentationStyle = .overFullScreen
    self.navigationController?.present(navigationController, animated: true)
  }
  
  private func categorySheet(agencyId: Int, categories: [MMCategory]) {
    let vc = LedgerFactory(
      contentFormatter: contentFormatter
    ).makeCategorySheet(agencyId: agencyId, categories: categories)
    vc.modalPresentationStyle = .overFullScreen
    navigationController?.present(vc, animated: false)
  }
  
  private func report(agencyID: Int) {
    let vc = LedgerFactory(
      contentFormatter: contentFormatter
    ).makeReport(agencyID: agencyID)
    let navigationController = UINavigationController(rootViewController: vc)
    navigationController.modalPresentationStyle = .fullScreen
    self.navigationController?.present(navigationController, animated: true)
  }
}
