import UIKit

import BaseFeature

import AgencyInterface
import UserInterface

import AgencyFeatureInterface

public struct AgencyFactory: AgencyFactoryInterface {
  
  public init() { }
  
  public func makeAgencyList() -> UIViewController {
    let vc = AgencyListVC()
    
    let getAgencyListUseCase = DIContainer.shared.resolve(type: GetAgencyListUseCaseInterface.self)
    let getMyAgencyUseCase = DIContainer.shared.resolve(type: GetMyAgencyUseCaseInterface.self)
    let getMyInfoUseCase = DIContainer.shared.resolve(type: GetMyInfoUseCaseInterface.self)
    let searchAgencyUseCase = DIContainer.shared.resolve(type: SearchAgencyUseCaseInterface.self)
    
    vc.reactor = AgencyListReactor(
      getAgencyListUseCase: getAgencyListUseCase,
      getMyAgencyUseCase: getMyAgencyUseCase,
      getMyInfoUseCase: getMyInfoUseCase,
      searchAgencyUseCase: searchAgencyUseCase
    )
    
    return vc
  }
  
  public func makeJoinAgency(agencyID: Int, agencyName: String) -> UIViewController {
    let vc = JoinAgencyVC()
    
    let usecase = DIContainer.shared
      .resolve(type: ConfirmCertificateCodeUseCaseInterface.self)
    
    vc.reactor = JoinAgencyReactor(
      id: agencyID,
      name: agencyName,
      confirmCertificateCodeUseCase: usecase
    )
    return UINavigationController(rootViewController: vc)
  }
  
  public func makeJoinComplete() -> UIViewController {
    let vc = JoinCompleteVC()
    vc.reactor = JoinCompleteReactor()
    return vc
  }
}
