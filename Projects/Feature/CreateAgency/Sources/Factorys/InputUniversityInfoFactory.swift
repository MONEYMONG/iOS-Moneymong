import UIKit

import Core
import CreateAgencyInterface

public struct InputUniversityInfoFactory: InputUniversityInfoFactoryInterface {
  
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface
  
  public init(networkManager: NetworkManagerInterfacae, localStorage: LocalStorageInterface) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }
  
  public func make(coordinator: CreateAgencyCoordinator?, agencyName: String, agencyType: AgencyType) -> UIViewController {
    let vc = InputUniversityInfoVC(completeFactory: CreateCompleteFactory(networkManager: networkManager, localStorage: localStorage))
    vc.coordinator = coordinator
    vc.reactor = InputUniversityInfoReactor(
      agencyName: agencyName,
      agencyType: agencyType,
      universityRepository: UniversityRepository(networkManager: networkManager),
      agencyRepository: AgencyRepository(networkManager: networkManager, localStorage: localStorage)
    )
    return vc
  }
}
