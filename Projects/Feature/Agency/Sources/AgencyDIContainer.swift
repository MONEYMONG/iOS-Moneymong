public final class AgencyDIContainer {
  public init() {}

  func agency(with coordinator: AgencyCoordinator) -> AgencyVC {
    let vc = AgencyVC()
    vc.reactor = AgencyReactor()
    vc.coordinator = coordinator
    return vc
  }
}
