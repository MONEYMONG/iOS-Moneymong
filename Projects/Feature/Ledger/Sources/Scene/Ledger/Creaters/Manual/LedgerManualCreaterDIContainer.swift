import UIKit

import NetworkService

final class LedgerManualCreaterDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(repo: LedgerRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = repo
    self.ledgerService = ledgerService
  }
  
  func manualCreater(with coordinator: LedgerManualCreaterCoordinator, agencyId: Int) -> LedgerManualCreaterVC {
    let vc = LedgerManualCreaterVC()
    vc.reactor = LedgerManualCreaterReactor(
      agencyId: agencyId,
      repo: ledgerRepo,
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

