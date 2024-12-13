import UIKit

import Core
import CreateAgencyInterface

public struct InputAgencyInfoFactory: InputAgencyInfoFactoryInterface {
  
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface
    
  public init(networkManager: NetworkManagerInterfacae, localStorage: LocalStorageInterface) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }
  
  public func make(coordinator: CreateAgencyCoordinator, universityType: UniversityType) -> UIViewController {
    let vc = InputAgencyInfoVC(
      createCompleteFactory: CreateCompleteFactory(networkManager: networkManager, localStorage: localStorage),
      inputUniversityInfoFactory: InputUniversityInfoFactory(networkManager: networkManager, localStorage: localStorage)
    )
    vc.coordinator = coordinator
    vc.reactor = InputAgencyInfoReactor(
      universityType: universityType,
      agencyRepo: AgencyRepository(networkManager: networkManager),
      universityRepo: UniversityRepository(networkManager: networkManager)
    )
    
    return vc
  }
}
