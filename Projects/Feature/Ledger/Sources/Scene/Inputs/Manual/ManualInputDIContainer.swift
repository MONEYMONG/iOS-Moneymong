import UIKit

import NetworkService

final class ManualInputDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(ledgerRepo: LedgerRepositoryInterface, userRepo: UserRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.ledgerService = ledgerService
  }
  
  func manualInput(with coordinator: ManualInputCoordinator, isClubBudget: Bool, agencyId: Int) -> ManualInputVC {
    let vc = ManualInputVC()
    vc.reactor = ManualInputReactor(
      agencyId: agencyId,
      type: isClubBudget ? .operatingCost : .other,
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

