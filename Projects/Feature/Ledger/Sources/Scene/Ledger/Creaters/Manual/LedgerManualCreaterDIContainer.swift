import UIKit

import NetworkService

final class LedgerManualCreaterDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(ledgerRepo: LedgerRepositoryInterface, userRepo: UserRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.ledgerService = ledgerService
  }
  
  func manualCreater(with coordinator: LedgerManualCreaterCoordinator, isClubBudget: Bool, agencyId: Int) -> LedgerManualCreaterVC {
    let vc = LedgerManualCreaterVC()
    vc.reactor = LedgerManualCreaterReactor(
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

