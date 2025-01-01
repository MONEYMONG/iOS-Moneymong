import UIKit

import Core
import CreateAgencyInterface

public final class AgencyDIContainer {
  
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae

  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  private let inputAgencyInfoFactory: InputAgencyInfoFactoryInterface
    
  public init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae,
    inputAgencyInfoFactory: InputAgencyInfoFactoryInterface
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
    self.agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
    self.userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage)
    self.inputAgencyInfoFactory = inputAgencyInfoFactory
  }

  func agency(with coordinator: AgencyCoordinator) -> AgencyListVC {
    let vc = AgencyListVC()
    vc.reactor = AgencyListReactor(agencyRepo: agencyRepo, userRepo: userRepo)
    vc.coordinator = coordinator
    return vc
  }
  
  func createAgency(with coordinator: AgencyCoordinator, universityType: UniversityType) -> UIViewController {
    let navigationController = UINavigationController()
    let createAgencyCoordinator = CreateAgencyCoordinator(navigationController: navigationController, inputAgencyFactory: inputAgencyInfoFactory)
    createAgencyCoordinator.parentCoordinator = coordinator
    createAgencyCoordinator.start(animated: true, universityType: universityType)
    return navigationController
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
