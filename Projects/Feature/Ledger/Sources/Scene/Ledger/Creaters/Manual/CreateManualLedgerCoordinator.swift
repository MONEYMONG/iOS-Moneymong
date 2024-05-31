import UIKit

import BaseFeature
import DesignSystem

final class CreateManualLedgerCoordinator: Coordinator {
  unowned var navigationController: UINavigationController
  private let diContainer: CreateManualLedgerDIContainer
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  enum Scene {
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
  }

  init(navigationController: UINavigationController, diContainer: CreateManualLedgerDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  func start(agencyId: Int, type: CreateManualLedgerReactor.`Type`, animated: Bool) {
    createManualLedger(agencyId: agencyId, type: type, animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .imagePicker(delegate): imagePicker(animated: animated, delegate: delegate)
    case let .alert(title, subTitle, type): alert(animated: animated, title: title, subTitle: subTitle, type: type)
    }
  }
}

extension CreateManualLedgerCoordinator {
  private func createManualLedger(agencyId: Int, type: CreateManualLedgerReactor.`Type`, animated: Bool) {
    let vc = diContainer.createManualLedger(with: self, type: type, agencyId: agencyId)
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
