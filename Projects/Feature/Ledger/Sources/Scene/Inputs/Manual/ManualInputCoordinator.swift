import UIKit

import BaseFeature
import DesignSystem

final class ManualInputCoordinator: Coordinator {
  var navigationController: UINavigationController
  private let diContainer: ManualInputDIContainer
  weak var parentCoordinator: (Coordinator)?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case alert(title: String, subTitle: String?, okAction: () -> Void)
  }

  init(navigationController: UINavigationController, diContainer: ManualInputDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(animated: Bool) {
    manualInput(animated: animated)
  }
  
  func dismiss(animated: Bool) {
    navigationController.dismiss(animated: animated) { [weak self] in
      self?.remove()
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .imagePicker(delegate): imagePicker(animated: animated, delegate: delegate)
    case let .alert(title, subTitle, okAction): alert(animated: animated, title: title, subTitle: subTitle, okAction: okAction)
    }
  }
}

extension ManualInputCoordinator {
  private func manualInput(animated: Bool) {
    let vc = diContainer.manualInput(with: self)
    navigationController.viewControllers = [vc]
  }
  
  private func imagePicker(animated: Bool, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    let picker = diContainer.imagePicker()
    picker.delegate = delegate
    picker.modalPresentationStyle = .fullScreen
    navigationController.present(picker, animated: animated)
  }
  
  private func alert(animated: Bool, title: String, subTitle: String?, okAction: @escaping () -> Void) {
    AlertsManager.show(
      navigationController,
      title: title,
      subTitle: subTitle,
      okAction: okAction,
      cancelAction: {}
    )
  }
}
