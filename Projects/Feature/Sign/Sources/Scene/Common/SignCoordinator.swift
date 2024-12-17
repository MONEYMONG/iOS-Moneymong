import UIKit

import BaseFeatureInterface
import CreateAgencyInterface
import DesignSystem

public final class SignCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: SignDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  public init(navigationController: UINavigationController, diContainer: SignDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    splash()
  }
  
  public func move(to scene: Scene) {
    switch scene {
    case .main:
      parentCoordinator?.move(to: .main)
      remove()
    case .ledger:
      parentCoordinator?.move(to: .ledger)
      remove()
    case .createManualLedger(let id):
      parentCoordinator?.move(to: .createManualLedger(id))
      remove()
    default: break
    }
  }
  
  deinit {
    debugPrint(#function)
  }
}

public extension SignCoordinator {
  func splash(animated: Bool = false) {
    let vc = diContainer.splash(with: self)
    navigationController.isNavigationBarHidden = false
    navigationController.viewControllers = [vc]
  }

  func login(animated: Bool = false) {
    let vc = diContainer.login(with: self)
    self.navigationController.pushViewController(vc, animated: animated)
  }

  func main() {
    parentCoordinator?.move(to: .main)
    remove()
  }

  func createAgency(animated: Bool = true) {
    let vc = diContainer.createAgency(with: self)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }

  func congratulations(animated: Bool = true) {
    let vc = diContainer.congratulations(with: self)
    navigationController.pushViewController(vc, animated: animated)
  }

  func pop(animated: Bool = true) {
    navigationController.popViewController(animated: animated)
  }

  func alert(title: String, okAction: (() -> Void)? = nil) {
    if let okAction {
      AlertsManager.show(title: title, type: .onlyOkButton(okAction))
    } else {
      AlertsManager.show(title: title)
    }
  }
}
