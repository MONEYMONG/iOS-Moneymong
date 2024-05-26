import UIKit

import NetworkService

final class LedgerScanCreaterDIContainer {
  private let ledgerRepo: LedgerRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(repo: LedgerRepositoryInterface, ledgerService: LedgerServiceInterface) {
    self.ledgerRepo = repo
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
    agencyId: Int,
    model: OCRResult,
    imageData: Data,
    with coordinator: LedgerScanCreaterCoordinator
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
}

