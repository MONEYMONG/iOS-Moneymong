import UIKit

import BaseFeature

public final class ManualInputCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: ManualInputDIContainer
  public weak var parentCoordinator: (Coordinator)?
  public var childCoordinators: [Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: ManualInputDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
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
