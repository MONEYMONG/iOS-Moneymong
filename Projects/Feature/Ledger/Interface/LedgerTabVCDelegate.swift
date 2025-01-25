import UIKit

import LedgerInterface

public protocol LedgerTabVCDelegate: AnyObject {
  func didTapManualInputButton(agencyID: Int)
  func didTapScanButton(agencyID: Int)
  func didTapDateRangeButton(start: DateInfo, end: DateInfo)
}
