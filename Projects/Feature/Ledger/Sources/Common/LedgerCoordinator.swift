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
    case inputManual
    case datePicker(start: DateInfo, end: DateInfo)
    case detail(Ledger)
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
    case .inputManual: manualInput(animated: animated)
    case let .datePicker(start, end):
      datePicker(start: start, end: end)
    case let .editMember(id, member):
      editMember(agencyID: id, member: member)
    case let .alert(title, subTitle, type):
      AlertsManager.show(title: title, subTitle: subTitle, type: type)
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
  
  private func manualInput(animated: Bool) {
    let vc = diContainer.manualInput(with: self)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }
  
  private func datePicker(start: DateInfo, end: DateInfo) {
    let vc = diContainer.datePicker(start: start, end: end)
    vc.modalPresentationStyle = .overFullScreen
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
