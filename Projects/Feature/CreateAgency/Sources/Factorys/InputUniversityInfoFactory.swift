import UIKit

import Core
import CreateAgencyInterface

public struct InputUniversityInfoFactory: InputUniversityInfoFactoryInterface {
  
  private let networkManager: NetworkManagerInterfacae
  
  public init(networkManager: NetworkManagerInterfacae) {
    self.networkManager = networkManager
  }
  
  public func make(agencyName: String, agencyType: AgencyType) -> UIViewController {
    let vc = InputUniversityInfoVC()
    vc.reactor = InputUniversityInfoReactor(
      agencyName: agencyName,
      agencyType: agencyType,
      universityRepository: UniversityRepository(networkManager: networkManager),
      agencyRepository: AgencyRepository(networkManager: networkManager)
    )
    return vc
  }
}
