import UIKit

import BaseFeature

final class ManualInputCoordinator: Coordinator {
  var navigationController: UINavigationController
  private let diContainer: ManualInputDIContainer
  weak var parentCoordinator: (Coordinator)?
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController, diContainer: ManualInputDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(animated: Bool) {
    manualInput(animated: animated)
  }
}

extension ManualInputCoordinator {
  private func manualInput(animated: Bool) {
    let vc = diContainer.manualInput(with: self)
    navigationController.viewControllers = [vc]
  }
  
  func dismiss(animated: Bool) {
    navigationController.dismiss(animated: animated) { [weak self] in
      self?.remove()
    }
  }
  
  func imagePicker(animated: Bool, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    let picker = diContainer.imagePicker()
    picker.delegate = delegate
    picker.modalPresentationStyle = .fullScreen
    navigationController.present(picker, animated: animated)
  }
}
