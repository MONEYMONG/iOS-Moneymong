import UIKit

import NetworkService

final class ManualInputDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  
  init(repo: LedgerRepositoryInterface) {
    self.ledgerRepo = repo
  }
  
  func manualInput(with coordinator: ManualInputCoordinator) -> ManualInputVC {
    let vc = ManualInputVC()
    vc.reactor = ManualInputReactor(repo: ledgerRepo)
    vc.coordinator = coordinator
    return vc
  }
  
  func imagePicker() -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    return picker
  }
}

