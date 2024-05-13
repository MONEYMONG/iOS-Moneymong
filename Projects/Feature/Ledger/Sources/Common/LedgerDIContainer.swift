import UIKit

import LocalStorage
import NetworkService
import BaseFeature
import NetworkService

public final class LedgerDIContainer {
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae
  private let ledgerService: LedgerServiceInterface = LedgerService()
  
  public init(localStorage: LocalStorageInterface, networkManager: NetworkManagerInterfacae) {
    self.localStorage = localStorage
    self.networkManager = networkManager
  }
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(
    ledgerRepo: LedgerRepositoryInterface
  ) {
    self.ledgerRepo = ledgerRepo
  }

  func ledger(with coordinator: LedgerCoordinator) -> LedgerVC {
    let vc = LedgerVC(
      [
        ledgerTab(with: coordinator),
        memberTab(with: coordinator)
      ]
    )
    vc.reactor = LedgerReactor(
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage),
      agencyRepo: AgencyRepository(networkManager: networkManager),
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  private func ledgerTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = LedgerTabVC()
    vc.title = "장부"
    vc.reactor = LedgerTabReactor()
    vc.coordinator = coordinator
    return vc
  }
  
  private func memberTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = MemberTabVC()
    vc.title = "멤버"
    vc.reactor = MemberTabReactor(
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage),
      agencyRepo: AgencyRepository(networkManager: networkManager),
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  func manualInput(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let manualInputCoordinator = ManualInputCoordinator(
      navigationController: vc,
      diContainer: ManualInputDIContainer(repo: ledgerRepo)
    )
    coordinator.childCoordinators.append(manualInputCoordinator)
    manualInputCoordinator.parentCoordinator = coordinator
    manualInputCoordinator.start(animated: false)
    return vc
  }
  
  func editMember(agencyID: Int, member: Member, with coordinator: LedgerCoordinator) -> EditMemberSheetVC {
    let vc = EditMemberSheetVC()
    vc.coordinator = coordinator
    vc.reactor = EditMemberReactor(
      agencyID: agencyID,
      member: member,
      agencyRepo: AgencyRepository(networkManager: networkManager),
      ledgerService: ledgerService
  func datePicker() -> UIViewController {
    let vc = DatePickerSheetVC()
    vc.reactor = DatePickerReactor(
      startDate: .init(year: 2023, month: 1),
      endDate: .init(year: 2023, month: 6)
    )
    return vc
  }
}
