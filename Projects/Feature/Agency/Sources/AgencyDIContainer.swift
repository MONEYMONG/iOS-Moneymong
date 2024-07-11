import UIKit

import Core

public final class AgencyDIContainer {
  
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae

  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  public init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
    self.agencyRepo = AgencyRepository(networkManager: networkManager)
    self.userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage)
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
    let vc = CreateCompleteVC()
    vc.reactor = CreateCompleteReactor(userRepo: userRepo, id: id)
    vc.coordinator = coordinator
    return vc
  }
  
  func joinAgency(id: Int, name: String, with coordinator: AgencyCoordinator) -> UIViewController {
    let vc = JoinAgencyVC()
    let rootVC = UINavigationController(rootViewController: vc)
    vc.reactor = JoinAgencyReactor(id: id, name: name, agencyRepo: agencyRepo, userRepo: userRepo)
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
