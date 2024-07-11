import UIKit

import Core
import BaseFeature

public final class LedgerDIContainer {

  private let ledgerService: LedgerServiceInterface = LedgerService()
  private let contentFormetter = ContentFormatter()
  
  private let ledgerRepo: LedgerRepositoryInterface
  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  public init(
    ledgerRepo: LedgerRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface,
    userRepo: UserRepositoryInterface
  ) {
    self.ledgerRepo = ledgerRepo
    self.agencyRepo = agencyRepo
    self.userRepo = userRepo
  }

  func ledger(with coordinator: LedgerCoordinator) -> LedgerVC {
    let vc = LedgerVC(
      [
        ledgerTab(with: coordinator),
        memberTab(with: coordinator)
      ]
    )
    vc.reactor = LedgerReactor(
      userRepo: userRepo,
      agencyRepo: agencyRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }

  private func ledgerTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = LedgerTabVC()
    vc.title = "장부"
    vc.reactor = LedgerTabReactor(
      ledgerService: ledgerService,
      ledgerRepo: ledgerRepo,
      userRepo: userRepo,
      agencyRepo: agencyRepo,
      formatter: contentFormetter
    )
    vc.coordinator = coordinator
    return vc
  }
  
  private func memberTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = MemberTabVC()
    vc.title = "멤버"
    vc.reactor = MemberTabReactor(
      userRepo: userRepo,
      agencyRepo: agencyRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  func createManualLedger(
    with coordinator: Coordinator,
    agencyId: Int,
    type: CreateManualLedgerReactor.`Type`
  ) -> UIViewController {
    let vc = UINavigationController()
    let manualCreaterCoordinator = CreateManualLedgerCoordinator(
      navigationController: vc,
      diContainer: CreateManualLedgerDIContainer(
        ledgerRepo: ledgerRepo,
        userRepo: userRepo,
        ledgerService: ledgerService,
        formatter: contentFormetter
      )
    )
    coordinator.childCoordinators.append(manualCreaterCoordinator)
    manualCreaterCoordinator.parentCoordinator = coordinator
    manualCreaterCoordinator.start(agencyId: agencyId, type: type, animated: false)
    return vc
  }
  func createOCRLedger(agencyId: Int, with coordinator: Coordinator) -> UIViewController {
    let nv = UINavigationController()
    let scanCreatercoordinator = CreateOCRLedgerCoordinator(
      navigationController: nv,
      diContainer: CreateOCRLedgerDIContainer(
        ledgerRepo: ledgerRepo,
        userRepo: userRepo,
        ledgerService: ledgerService,
        formatter: contentFormetter
      )
    )
    coordinator.childCoordinators.append(scanCreatercoordinator)
    scanCreatercoordinator.parentCoordinator = coordinator
    scanCreatercoordinator.start(agencyId: agencyId, animated: false)
    return nv
  }
  
  func editMember(agencyID: Int, member: Member, with coordinator: LedgerCoordinator) -> EditMemberSheetVC {
    let vc = EditMemberSheetVC()
    vc.coordinator = coordinator
    vc.reactor = EditMemberReactor(
      agencyID: agencyID,
      member: member,
      agencyRepo: agencyRepo,
      ledgerService: ledgerService
    )
    return vc
  }
  
  func datePicker(start: DateInfo, end: DateInfo) -> UIViewController {
    let vc = DatePickerSheetVC()
    vc.reactor = DatePickerReactor(
      startDate: start,
      endDate: end,
      ledgerService: ledgerService,
      formatter: contentFormetter
    )
    return vc
  }
  
  func selectAgencySheet(with coordinator: LedgerCoordinator) -> SelectAgencySheetVC {
    let vc = SelectAgencySheetVC()
    vc.coordinator = coordinator
    vc.reactor = SelectAgencySheetReactor(
      agencyRepo: agencyRepo,
      userRepo: userRepo,
      service: ledgerService
    )
    return vc
  }

  func detail(
    with coordinator: LedgerCoordinator,
    ledgerID: Int,
    role: Member.Role
  ) -> LedgerDetailVC {
    let service = LedgerDetailContentsService()

    let contentsView = LedgerContentsView(
      coordinator: coordinator,
      reactor: .init(
        ledgerContentsService: service,
        ledgerRepo: ledgerRepo,
        formatter: contentFormetter
      )
    )

    let vc = LedgerDetailVC(contentsView: contentsView)
    vc.coordinator = coordinator
    vc.reactor = LedgerDetailReactor(
      ledgerID: ledgerID,
      role: role,
      ledgerRepository: ledgerRepo,
      ledgerService: ledgerService,
      ledgerContentsService: service
    )
    return vc
  }

  func imagePicker() -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    return picker
  }
}
