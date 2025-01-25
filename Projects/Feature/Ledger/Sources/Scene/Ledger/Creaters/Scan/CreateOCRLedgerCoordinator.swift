import UIKit

import BaseFeature
import DesignSystem
import Core
import LedgerInterface
import LedgerFeatureInterface

final class CreateOCRLedgerCoordinator: Coordinator {
  unowned var navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case snackBar(title: String)
    case scanResult(Int, model: OCRResult, imageData: Data)
    case createManualLedger(Int, ManualPresentType)
  }

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(agencyId: Int, animated: Bool) {
    guard let vc = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeOCR(agencyId: agencyId) as? CreateOCRLedgerVC else { return }
    vc.coordinator = self
    navigationController.viewControllers = [vc]
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
    guard let vc = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeOCRResult(agencyId: agencyId, model: model, imageData: imageData) as? OCRResultVC else { return }
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: animated)
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: ManualPresentType,
    animated: Bool
  ) {
    let vc = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeCreateManual(agencyId: agencyId, type: type)
    navigationController.pushViewController(vc, animated: animated)
  }
}
