import UIKit

import Core

final class CreateManualLedgerDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  private let contentFormatter: ContentFormatter
  
  init(
    ledgerRepo: LedgerRepositoryInterface,
    userRepo: UserRepositoryInterface,
    ledgerService: LedgerServiceInterface,
    formatter: ContentFormatter
  ) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.ledgerService = ledgerService
    self.contentFormatter = formatter
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
      ledgerService: ledgerService,
      formatter: contentFormatter
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

