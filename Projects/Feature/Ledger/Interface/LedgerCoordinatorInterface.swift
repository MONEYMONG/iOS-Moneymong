import UIKit

import AgencyInterface
import BaseFeature
import LedgerInterface

public protocol LedgerCoordinatorInterface: Coordinator {
  func start(animated: Bool)
}
