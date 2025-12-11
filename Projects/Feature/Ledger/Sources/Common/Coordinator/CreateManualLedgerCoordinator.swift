import UIKit

import BaseFeature
import DesignSystem
import LedgerFeatureInterface

public final class CreateManualLedgerCoordinator: CreateManualLedgerCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  private let contentFormatter: ContentFormatter
  
  enum Scene {
    case imagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    case alert(title: String, subTitle: String?, type: MMAlerts.`Type`)
  }
  

  public init(contentFormatter: ContentFormatter) {
    self.contentFormatter = contentFormatter
  }

  public func start(agencyId: Int, type: ManualPresentType, animated: Bool) {
    let vc = LedgerFactory(contentFormatter: contentFormatter).makeCreateManual(agencyId: agencyId, type: type)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}
