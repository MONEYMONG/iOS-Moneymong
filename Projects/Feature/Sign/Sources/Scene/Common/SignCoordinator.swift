import UIKit

import AgencyFeatureInterface
import BaseFeature
import DesignSystem

public final class SignCoordinator: Coordinator {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  public init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }

  public func start(animated: Bool) {
    splash()
  }
}

public extension SignCoordinator {
  func splash(animated: Bool = false) {
    guard let vc = SignFactory().makeSplash() as? SplashVC else { return }
    vc.coordinator = self
    navigationController?.isNavigationBarHidden = false
    navigationController?.viewControllers = [vc]
  }

  func login(animated: Bool = false) {
    guard let vc =  SignFactory().makeLogin() as? LoginVC else { return }
    vc.coordinator = self
    self.navigationController?.pushViewController(vc, animated: animated)
  }

  func createAgency(animated: Bool = true) {
    let root = UINavigationController()
    root.modalPresentationStyle = .fullScreen
    let coordinator = DIContainer.shared.resolve(type: CreateAgencyCoordinatorInterface.self)
    coordinator.navigationController = root
    coordinator.parentCoordinator = self
    coordinator.start(animated: animated)

    navigationController?.present(root, animated: animated)
  }

  func congratulations(animated: Bool = true) {
    guard let vc =  SignFactory().makeCongratulation() as? CongratulationsVC else { return }
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }

  func pop(animated: Bool = true) {
    navigationController?.popViewController(animated: animated)
  }

  func alert(title: String, okAction: (() -> Void)? = nil) {
    if let okAction {
      AlertsManager.show(title: title, type: .onlyOkButton(okAction))
    } else {
      AlertsManager.show(title: title)
    }
  }
}
