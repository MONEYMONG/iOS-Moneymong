import BaseFeature

final class ChildLedgerDIContainer {
  func childLedger(with coordinator: Coordinator) -> ChildLedgerVC {
    let vc = ChildLedgerVC()
    vc.reactor = ChildLedgerReactor()
    vc.coordinator = coordinator
    return vc
  }
}
