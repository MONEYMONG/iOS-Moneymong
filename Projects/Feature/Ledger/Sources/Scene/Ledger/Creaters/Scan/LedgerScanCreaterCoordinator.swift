import UIKit

import BaseFeature
import DesignSystem
import NetworkService

final class LedgerScanCreaterCoordinator: Coordinator {
  unowned var navigationController: UINavigationController
  private let diContainer: LedgerScanCreaterDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case guide
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
    case snackBar(title: String)
    case scanResult(Int, model: OCRResult, imageData: Data)
    case manualCreater(Int, LedgerManualCreaterReactor.State.Starting)
  }

  init(navigationController: UINavigationController, diContainer: LedgerScanCreaterDIContainer) {
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
    case let .manualCreater(agencyId, type):
      manualCreater(
        agencyId: agencyId,
        from: type,
        animated: animated
      )
    }
  }
}

extension LedgerScanCreaterCoordinator {
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
  
  private func manualCreater(
    agencyId: Int,
    from type: LedgerManualCreaterReactor.State.Starting,
    animated: Bool
  ) {
    diContainer.manualCreater(with: self, agencyId: agencyId, from: type)
  }
}
