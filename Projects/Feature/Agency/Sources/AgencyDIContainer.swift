public final class AgencyDIContainer {
  public init() {}

  func agency(with coordinator: AgencyCoordinator) -> AgencyViewController {
    let vc = AgencyViewController()
    vc.reactor = AgencyReactor()
    vc.coordinator = coordinator
    return vc
  }
}
