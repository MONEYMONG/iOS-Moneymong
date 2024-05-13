import UIKit

import BaseFeature
import NetworkService

public final class LedgerDIContainer {
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
        memberTab()
      ]
    )
    vc.reactor = LedgerReactor()
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
  
  private func memberTab() -> UIViewController {
    let vc = MemberTabVC()
    vc.title = "멤버"
    vc.reactor = MemberTabReactor()
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
  
  func datePicker() -> UIViewController {
    let vc = DatePickerSheetVC()
    vc.reactor = DatePickerReactor(
      startDate: .init(year: 2023, month: 1),
      endDate: .init(year: 2023, month: 6)
    )
    return vc
  }
}
