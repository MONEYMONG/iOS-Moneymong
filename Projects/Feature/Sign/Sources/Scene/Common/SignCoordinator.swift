import UIKit

import BaseFeature
import BaseFeatureInterface
import CreateAgencyInterface
import DesignSystem
import SignFeatureInterface

public final class SignCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
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
    guard let vc = DIContainer.shared.resolve(type: SignFactoryInterface.self).makeSplash() as? SplashVC else { return }
    navigationController.isNavigationBarHidden = false
    navigationController.viewControllers = [vc]
  }

  func login(animated: Bool = false) {
    guard let vc = DIContainer.shared.resolve(type: SignFactoryInterface.self).makeLogin() as? LoginVC else { return }
    vc.coordinator = self
    self.navigationController.pushViewController(vc, animated: animated)
  }

  func main() {
    parentCoordinator?.move(to: .main)
    remove()
  }

  func createAgency(animated: Bool = true) {
    let vc = UINavigationController()
    let coordinator = CreateAgencyCoordinator(navigationController: vc)
    coordinator.parentCoordinator = self
    childCoordinators.append(coordinator)
    coordinator.start(animated: true, universityType: .unknown)
    vc.modalPresentationStyle = .fullScreen
    navigationController.present(vc, animated: animated)
  }

  func congratulations(animated: Bool = true) {
    guard let vc = DIContainer.shared.resolve(type: SignFactoryInterface.self).makeCongratulation() as? CongratulationsVC else { return }
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: animated)
  }

  func pop(animated: Bool = true) {
    navigationController.popViewController(animated: animated)
  }
}
