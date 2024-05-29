import UIKit

import BaseFeature
import NetworkService

final class LedgerScanCreaterDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(ledgerRepo: LedgerRepositoryInterface, userRepo: UserRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.ledgerService = ledgerService
  }
  
  func scanCreater(agencyId: Int, with coordinator: LedgerScanCreaterCoordinator) -> LedgerScanCreaterVC {
    let vc = LedgerScanCreaterVC()
    vc.coordinator = coordinator
    vc.reactor = LedgerScanCreaterReactor(agencyId: agencyId, ledgerRepo: ledgerRepo)
    return vc
  }
  
  func scanGuide() -> UIViewController {
    let vc = UINavigationController(rootViewController: ScanGuideVC())
    vc.modalPresentationStyle = .overFullScreen
    return vc
  }
  
  func scanResult(
    with coordinator: LedgerScanCreaterCoordinator,
    agencyId: Int,
    model: OCRResult,
    imageData: Data
  ) -> UIViewController {
    let vc = LedgerScanResultVC()
    vc.reactor = LedgerScanResultReactor(
      agencyId: agencyId,
      model: model,
      imageData: imageData,
      repo: ledgerRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  func manualCreater(with coordinator: Coordinator, agencyId: Int, from type: LedgerManualCreaterReactor.State.Starting) {
    let manualCreaterCoordinator = LedgerManualCreaterCoordinator(
      navigationController: coordinator.navigationController,
      diContainer: LedgerManualCreaterDIContainer(
        ledgerRepo: ledgerRepo,
        userRepo: userRepo,
        ledgerService: ledgerService
      )
    )
    coordinator.childCoordinators.append(manualCreaterCoordinator)
    manualCreaterCoordinator.parentCoordinator = coordinator
    manualCreaterCoordinator.start(agencyId: agencyId, from: type, animated: true)
  }
}

