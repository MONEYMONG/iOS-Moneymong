import UIKit

import BaseFeature
import DesignSystem
import Core
import LedgerInterface
import LedgerFeatureInterface

public final class CreateOCRLedgerCoordinator: CreateOCRLedgerCoordinatorInterface {
  weak public var navigationController: UINavigationController?
  weak public var parentCoordinator: Coordinator?
  
  private let ledgerService: LedgerServiceInterface
  private let contentFormatter: ContentFormatter
  
  enum Scene {
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case snackBar(title: String)
    case scanResult(Int, model: OCRResult, imageData: Data)
    case createManualLedger(Int, ManualPresentType)
  }

  public init(ledgerService: LedgerServiceInterface, contentFormatter: ContentFormatter) {
    self.ledgerService = ledgerService
    self.contentFormatter = contentFormatter
  }

  public func start(agencyId: Int, animated: Bool) {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeOCR(agencyId: agencyId)
    vc.coordinator = self
    navigationController?.viewControllers = [vc]
  }
  
  @MainActor func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, type):
      AlertsManager.show(title: title, subTitle: subTitle, type: type)
    case let .scanResult(id, model, data):
      scanResult(agencyId: id, model: model, imageData: data)
    case let .snackBar(title: title):
      SnackBarManager.show(title: title)
    case let .createManualLedger(agencyId, type):
      createManualLedger(
        agencyId: agencyId,
        type: type,
        animated: animated
      )
    }
  }
}

extension CreateOCRLedgerCoordinator {
  private func scanResult(agencyId: Int, model: OCRResult, imageData: Data, animated: Bool = true) {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeOCRResult(agencyId: agencyId, model: model, imageData: imageData)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: ManualPresentType,
    animated: Bool
  ) {
    let vc = LedgerFactory(ledgerService: ledgerService, contentFormatter: contentFormatter).makeCreateManual(agencyId: agencyId, type: type)
    navigationController?.pushViewController(vc, animated: animated)
  }
}
