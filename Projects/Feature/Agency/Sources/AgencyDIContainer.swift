import UIKit

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

  func agency(with coordinator: AgencyCoordinator) -> AgencyListVC {
    let vc = AgencyListVC()
    vc.reactor = AgencyListReactor(agencyRepo: agencyRepo)
    vc.coordinator = coordinator
    return vc
  }
  
  func createAgency(with coordinator: AgencyCoordinator) -> UIViewController {
    let vc = CreateAgencyVC()
    let rootVC = UINavigationController(rootViewController: vc)
    vc.reactor = CreateAgencyReactor(agencyRepo: agencyRepo)
    vc.coordinator = coordinator
    return rootVC
  }
  
  func createComplete(with coordinator: AgencyCoordinator, id: Int) -> CreateCompleteVC {
    let vc = CreateCompleteVC(id: id)
    vc.coordinator = coordinator
    return vc
  }
  
  func joinAgency(id: Int, name: String, with coordinator: AgencyCoordinator) -> UIViewController {
    let vc = JoinAgencyVC()
    let rootVC = UINavigationController(rootViewController: vc)
    vc.reactor = JoinAgencyReactor(id: id, name: name, repo: agencyRepo)
    vc.coordinator = coordinator
    return rootVC
  }
  
  func joinComplete(with coordinator: AgencyCoordinator) -> JoinCompleteVC {
    let vc = JoinCompleteVC()
    vc.reactor = JoinCompleteReactor()
    vc.coordinator = coordinator
    return vc
  }
}
