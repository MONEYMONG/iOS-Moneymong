import UIKit

import BaseFeature

public final class LedgerCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: LedgerDIContainer
  public weak var parentCoordinator: (Coordinator)?
  public var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case inputManual
    case datePicker
  }

  public init(navigationController: UINavigationController, diContainer: LedgerDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    ledger(animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case .inputManual: manualInput(animated: animated)
    case .datePicker: datePicker(animated: animated)
    }
  }
}

extension LedgerCoordinator {
  private func ledger(animated: Bool) {
    let vc = diContainer.ledger(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func manualInput(animated: Bool) {
    let vc = diContainer.manualInput(with: self)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }
  
  private func datePicker(animated: Bool) {
    let vc = diContainer.datePicker()
    vc.modalPresentationStyle = .overFullScreen
    navigationController.present(vc, animated: false)
  }
}
