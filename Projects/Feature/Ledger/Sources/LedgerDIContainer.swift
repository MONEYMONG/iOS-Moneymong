import UIKit

import BaseFeature

public final class LedgerDIContainer {
  public init() {}
  
  func ledger(with coordinator: Coordinator) -> LedgerVC {
    let vc = LedgerVC(
      [
        ledgerTab(),
        memberTab()
      ]
    )
    vc.reactor = LedgerReactor()
    vc.coordinator = coordinator
    return vc
  }
  
  private func ledgerTab() -> UIViewController {
    let vc = LedgerTabVC()
    vc.title = "장부"
    vc.reactor = LedgerTabReactor()
    return vc
  }
  
  private func memberTab() -> UIViewController {
    let vc = MemberTabVC()
    vc.title = "멤버"
    vc.reactor = MemberTabReactor()
    return vc
  }
}
