import UIKit

import BaseFeature
import NetworkService

final class CreateOCRLedgerDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(ledgerRepo: LedgerRepositoryInterface, userRepo: UserRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.ledgerService = ledgerService
  }
  
  func scanCreater(agencyId: Int, with coordinator: CreateOCRLedgerCoordinator) -> CreateOCRLedgerVC {
    let vc = CreateOCRLedgerVC()
    vc.coordinator = coordinator
    vc.reactor = CreateOCRLedgerReactor(agencyId: agencyId, ledgerRepo: ledgerRepo)
    return vc
  }
  
  func scanGuide() -> UIViewController {
    let vc = UINavigationController(rootViewController: ScanGuideVC())
    vc.modalPresentationStyle = .overFullScreen
    return vc
  }
  
  func scanResult(
    with coordinator: CreateOCRLedgerCoordinator,
    agencyId: Int,
    model: OCRResult,
    imageData: Data
  ) -> UIViewController {
    let vc = OCRResultVC()
    vc.reactor = OCRResultReactor(
      agencyId: agencyId,
      model: model,
      imageData: imageData,
      repo: ledgerRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  func createManualLedger(with coordinator: Coordinator, agencyId: Int, type: CreateManualLedgerReactor.`Type`) {
    let manualCreaterCoordinator = CreateManualLedgerCoordinator(
      navigationController: coordinator.navigationController,
      diContainer: CreateManualLedgerDIContainer(
        ledgerRepo: ledgerRepo,
        userRepo: userRepo,
        ledgerService: ledgerService
      )
    )
    coordinator.childCoordinators.append(manualCreaterCoordinator)
    manualCreaterCoordinator.parentCoordinator = coordinator
    manualCreaterCoordinator.start(agencyId: agencyId, type: type, animated: true)
  }
}
