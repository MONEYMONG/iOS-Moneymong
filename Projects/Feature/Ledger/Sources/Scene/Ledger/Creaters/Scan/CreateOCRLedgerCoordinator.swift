import UIKit

import BaseFeature
import DesignSystem
import NetworkService

final class CreateOCRLedgerCoordinator: Coordinator {
  unowned var navigationController: UINavigationController
  private let diContainer: CreateOCRLedgerDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case guide
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case snackBar(title: String)
    case scanResult(Int, model: OCRResult, imageData: Data)
    case createManualLedger(Int, CreateManualLedgerReactor.`Type`)
  }

  init(navigationController: UINavigationController, diContainer: CreateOCRLedgerDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(agencyId: Int, animated: Bool) {
    scanCreater(agencyId: agencyId)
  }
  
  @MainActor func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .guide:
      scanGuide(animated: animated)
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
  private func scanCreater(agencyId: Int) {
    let vc = diContainer.scanCreater(agencyId: agencyId, with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func scanGuide(animated: Bool) {
    let vc = diContainer.scanGuide()
    navigationController.present(vc, animated: animated)
  }
  
  private func scanResult(agencyId: Int, model: OCRResult, imageData: Data, animated: Bool = true) {
    let vc = diContainer.scanResult(
      with: self,
      agencyId: agencyId,
      model: model,
      imageData: imageData
    )
    navigationController.pushViewController(vc, animated: animated)
  }
  
  private func createManualLedger(
    agencyId: Int,
    type: CreateManualLedgerReactor.`Type`,
    animated: Bool
  ) {
    diContainer.createManualLedger(with: self, agencyId: agencyId, type: type)
  }
}
