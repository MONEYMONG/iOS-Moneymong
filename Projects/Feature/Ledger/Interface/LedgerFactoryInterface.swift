import UIKit

import AgencyInterface
import LedgerInterface

public protocol LedgerFactoryInterface {
  func makeLedgerMain(ledgerTab: UIViewController, memberTab: UIViewController) -> UIViewController
  func makeLedgerTab() -> UIViewController
  func makeMemberTab(delegate: MemberTabVCDelegate?) -> UIViewController
  func makeCreateManual(agencyId: Int, type: ManualPresentType) -> UIViewController
  func makeOCR(agencyId: Int) -> UIViewController
  func makeOCRResult(agencyId: Int, model: OCRResult, imageData: Data) -> UIViewController
  func makeDatePicker(start: DateInfo, end: DateInfo) -> UIViewController
  func makeEditMember(agencyID: Int, member: Member) -> UIViewController
  func makeSelectAgency() -> UIViewController
  func makeDetail(ledgetID: Int, role: Member.Role) -> UIViewController
}
