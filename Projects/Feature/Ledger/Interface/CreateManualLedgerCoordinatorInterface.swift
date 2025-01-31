import UIKit

import AgencyInterface
import BaseFeature
import LedgerInterface

public protocol CreateManualLedgerCoordinatorInterface: Coordinator {
  func start(agencyId: Int, type: ManualPresentType, animated: Bool)
}
