public final class LedgerDIContainer {
  public init() {}

  func ledger(with coordinator: LedgerCoordinator) -> LedgerVC {
    let vc = LedgerVC()
    vc.reactor = LedgerReactor()
    vc.coordinator = coordinator
    return vc
  }
}
