import UIKit

import DesignSystem
import NetworkService
import BaseFeature

public final class LedgerCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: LedgerDIContainer
  public weak var parentCoordinator: (Coordinator)?
  public var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case editMember(Int, Member)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case manualCreater(Int, Bool)
    case scanCreater(Int)
    case datePicker(start: DateInfo, end: DateInfo)
    case detail(Ledger)
    case selectAgency
  }

  public init(navigationController: UINavigationController, diContainer: LedgerDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    ledger(animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .manualCreater(agencyId, isClubBudget):
      manualCreater(agencyId: agencyId, isClubBudget: isClubBudget, animated: animated)
    case let .datePicker(start, end):
      datePicker(start: start, end: end)
    case .selectAgency: selectAgencySheet()
    case let .editMember(id, member):
      editMember(agencyID: id, member: member)
    case let .alert(title, subTitle, type):
      AlertsManager.show(title: title, subTitle: subTitle, type: type)
    case let .scanCreater(id):
      scanCreater(agencyId: id, animated: animated)
    case let .detail(ledger):
      detail(ledgerID: ledger.id)
    }
  }

  func pop(animated: Bool = true) {
    navigationController.popViewController(animated: animated)
  }
}

extension LedgerCoordinator {
  
  private func ledger(animated: Bool) {
    let vc = diContainer.ledger(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func manualCreater(agencyId: Int, isClubBudget: Bool, animated: Bool) {
    let vc = diContainer.manualCreater(with: self, agencyId: agencyId, isClubBudget: isClubBudget)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }
  
  private func scanCreater(agencyId: Int, animated: Bool) {
    let vc = diContainer.scanCreater(agencyId: agencyId, with: self)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }
  
  private func datePicker(start: DateInfo, end: DateInfo) {
    let vc = diContainer.datePicker(start: start, end: end)
    vc.modalPresentationStyle = .overFullScreen
    navigationController.present(vc, animated: false)
  }
  
  private func selectAgencySheet() {
    let vc = diContainer.selectAgencySheet(with: self)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    navigationController.present(vc, animated: false)
  }
  
  private func editMember(agencyID: Int, member: Member, animated: Bool = false) {
    let vc = diContainer.editMember(agencyID: agencyID, member: member, with: self)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    navigationController.present(vc, animated: animated)
  }

  private func detail(ledgerID: Int, animated: Bool = true) {
    let vc = diContainer.detail(with: self, ledgerID: ledgerID)
    navigationController.pushViewController(vc, animated: animated)
  }
}
