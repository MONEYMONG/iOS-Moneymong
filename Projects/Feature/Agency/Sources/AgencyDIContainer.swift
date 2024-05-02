import Foundation

import LocalStorage
import NetworkService

public final class AgencyDIContainer {
  
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae

  private let agencyRepo: AgencyRepositoryInterface
  
  public init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
    self.agencyRepo = AgencyRepository(networkManager: networkManager)
  }

  func agency(with coordinator: AgencyCoordinator) -> AgencyVC {
    let vc = AgencyVC()
    vc.reactor = AgencyReactor(agencyRepo: agencyRepo)
    vc.coordinator = coordinator
    return vc
  }
}
