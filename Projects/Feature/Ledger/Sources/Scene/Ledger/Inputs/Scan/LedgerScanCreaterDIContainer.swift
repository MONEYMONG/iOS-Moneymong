import UIKit

import NetworkService

final class LedgerScanCreaterDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(repo: LedgerRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = repo
    self.ledgerService = ledgerService
  }
  
  func scanCreater(with coordinator: LedgerScanCreaterCoordinator) -> LedgerScanCreaterVC {
    let vc = LedgerScanCreaterVC()
    vc.coordinator = coordinator
    vc.reactor = LedgerScanCreaterReactor()
    return vc
  }
  
  func imagePicker() -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    return picker
  }
}

