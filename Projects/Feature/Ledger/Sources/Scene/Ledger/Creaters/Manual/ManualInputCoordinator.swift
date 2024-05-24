import UIKit

import BaseFeature
import DesignSystem

final class ManualInputCoordinator: Coordinator {
  var navigationController: UINavigationController
  private let diContainer: ManualInputDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
  }

  init(navigationController: UINavigationController, diContainer: ManualInputDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(agencyId: Int, animated: Bool) {
    manualCreater(agencyId: agencyId, animated: animated)
  }
  
  func dismiss(animated: Bool) {
    navigationController.dismiss(animated: animated) { [weak self] in
      self?.remove()
    }
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .imagePicker(delegate): imagePicker(animated: animated, delegate: delegate)
    case let .alert(title, subTitle, type): alert(animated: animated, title: title, subTitle: subTitle, type: type)
    }
  }
}

extension ManualInputCoordinator {
  private func manualCreater(agencyId: Int, animated: Bool) {
    let vc = diContainer.manualCreater(with: self, agencyId: agencyId)
    navigationController.viewControllers = [vc]
  }
  
  private func imagePicker(animated: Bool, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    let picker = diContainer.imagePicker()
    picker.delegate = delegate
    picker.modalPresentationStyle = .fullScreen
    navigationController.present(picker, animated: animated)
  }
  
  private func alert(
    animated: Bool,
    title: String,
    subTitle: String?,
    type: MMAlerts.`Type`
  ) {
    AlertsManager.show(
      title: title,
      subTitle: subTitle,
      type: type
    )
  }
}
