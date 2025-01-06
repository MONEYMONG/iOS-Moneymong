import UIKit

public protocol LedgerFactoryInterface {
  func makeLedgerMain(ledgerTap: UIViewController, memberTap: UIViewController) -> UIViewController
}
