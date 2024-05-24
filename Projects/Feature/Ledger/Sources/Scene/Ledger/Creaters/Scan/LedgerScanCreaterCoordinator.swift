import UIKit

import BaseFeature
import DesignSystem

final class LedgerScanCreaterCoordinator: Coordinator {
  var navigationController: UINavigationController
  private let diContainer: LedgerScanCreaterDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case guide
  }

  init(navigationController: UINavigationController, diContainer: LedgerScanCreaterDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(animated: Bool) {
    scanCreater()
  }
  
  func dismiss(animated: Bool) {
    navigationController.dismiss(animated: animated) { [weak self] in
      self?.remove()
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .guide:
      scanGuide(animated: animated)
    }
  }
}

extension LedgerScanCreaterCoordinator {
  private func scanCreater() {
    let vc = diContainer.scanCreater(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func scanGuide(animated: Bool) {
    let vc = diContainer.scanGuide()
    navigationController.present(vc, animated: animated)
  }
}
