import UIKit

import NetworkService

final class CreateManualLedgerDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(ledgerRepo: LedgerRepositoryInterface, userRepo: UserRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.ledgerService = ledgerService
  }
  
  func createManualLedger(
    with coordinator: CreateManualLedgerCoordinator,
    type: CreateManualLedgerReactor.`Type`,
    agencyId: Int
  ) -> CreateManualLedgerVC {
    let vc = CreateManualLedgerVC()
    vc.reactor = CreateManualLedgerReactor(
      agencyId: agencyId,
      type: type,
      ledgerRepo: ledgerRepo,
      userRepo: userRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  func imagePicker() -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    return picker
  }
}

