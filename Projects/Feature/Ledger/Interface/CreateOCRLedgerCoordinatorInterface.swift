import UIKit

import AgencyInterface
import BaseFeature
import LedgerInterface

public protocol CreateOCRLedgerCoordinatorInterface: Coordinator {
  func start(agencyId: Int, animated: Bool)
}
