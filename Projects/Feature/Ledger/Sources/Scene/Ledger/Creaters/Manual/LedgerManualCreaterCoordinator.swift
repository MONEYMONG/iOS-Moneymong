import UIKit

import BaseFeature
import DesignSystem

final class LedgerManualCreaterCoordinator: Coordinator {
  unowned var navigationController: UINavigationController
  private let diContainer: LedgerManualCreaterDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
  }

  init(navigationController: UINavigationController, diContainer: LedgerManualCreaterDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(agencyId: Int, from type: LedgerManualCreaterReactor.State.Starting, animated: Bool) {
    manualCreater(agencyId: agencyId, from: type, animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .imagePicker(delegate): imagePicker(animated: animated, delegate: delegate)
    case let .alert(title, subTitle, type): alert(animated: animated, title: title, subTitle: subTitle, type: type)
    }
  }
}

extension LedgerManualCreaterCoordinator {
  private func manualCreater(agencyId: Int, from type: LedgerManualCreaterReactor.State.Starting, animated: Bool) {
    let vc = diContainer.manualCreater(with: self, from: type, agencyId: agencyId)
    navigationController.pushViewController(vc, animated: animated)
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
