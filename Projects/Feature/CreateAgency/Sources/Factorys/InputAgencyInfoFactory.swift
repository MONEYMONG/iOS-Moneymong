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
  
  public func make() -> UIViewController {
    let vc = InputAgencyInfoVC(
      createCompleteFactory: CreateCompleteFactory(networkManager: networkManager, localStorage: localStorage),
      inputUniversityInfoFactory: InputUniversityInfoFactory()
    )
    vc.reactor = InputAgencyInfoReactor(
      agencyRepo: AgencyRepository(networkManager: networkManager),
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage)
    )
    
    return vc
  }
}
