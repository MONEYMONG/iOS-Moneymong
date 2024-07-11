import UIKit

import DesignSystem
import Core
import BaseFeature

public final class LedgerCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: LedgerDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case editMember(Int, Member)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case createManualLedger(Int, CreateManualLedgerReactor.`Type`)
    case createOCRLedger(Int)
    case datePicker(start: DateInfo, end: DateInfo)
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case detail(Ledger, Member.Role)
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
    case let .createManualLedger(agencyId, type):
      createManualLedger(agencyId: agencyId, type: type, animated: animated)
    case let .datePicker(start, end):
      datePicker(start: start, end: end)
    case let .imagePicker(delegate):
      imagePicker(animated: true, delegate: delegate)
    case .selectAgency:
      selectAgencySheet()
    case let .editMember(id, member):
      editMember(agencyID: id, member: member)
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
    let vc = diContainer.ledger(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: CreateManualLedgerReactor.`Type`,
    animated: Bool
  ) {
    let vc = diContainer.createManualLedger(with: self, agencyId: agencyId, type: type)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }
  
  private func createOCRLedger(agencyId: Int, animated: Bool) {
    let vc = diContainer.createOCRLedger(agencyId: agencyId, with: self)
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

  private func detail(ledgerID: Int, role: Member.Role, animated: Bool = true) {
    let vc = diContainer.detail(with: self, ledgerID: ledgerID, role: role)
    navigationController.pushViewController(vc, animated: animated)
  }

  private func imagePicker(
    animated: Bool,
    delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
  ) {
    let picker: UIImagePickerController = {
      let v = UIImagePickerController()
      v.sourceType = .photoLibrary
      return v
    }()
    picker.delegate = delegate
    picker.modalPresentationStyle = .fullScreen
    navigationController.present(picker, animated: animated)
  }
}
