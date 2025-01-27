import UIKit

import BaseFeature
import DesignSystem
import LedgerFeatureInterface

final class CreateManualLedgerCoordinator: Coordinator {
  weak var navigationController: UINavigationController?
  weak var parentCoordinator: Coordinator?
  
  enum Scene {
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
  }

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start(agencyId: Int, type: ManualPresentType, animated: Bool) {
    guard let vc = DIContainer.shared.resolve(type: LedgerFactoryInterface.self).makeCreateManual(agencyId: agencyId, type: type) as? CreateManualLedgerVC else { return }
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
}
