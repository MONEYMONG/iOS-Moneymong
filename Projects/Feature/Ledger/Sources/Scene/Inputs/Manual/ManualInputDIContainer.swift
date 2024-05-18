import UIKit

import NetworkService

final class ManualInputDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(repo: LedgerRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = repo
    self.ledgerService = ledgerService
  }
  
  func manualInput(with coordinator: ManualInputCoordinator) -> ManualInputVC {
    let vc = ManualInputVC()
    vc.reactor = ManualInputReactor(
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

