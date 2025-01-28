import UIKit

import AgencyInterface
import AgencyFeatureInterface
import BaseFeature
import UserInterface

struct AgencyFactory {
  
  init() { }
  
  func makeAgencyList() -> AgencyListVC {
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
  
  func makeJoinAgency(agencyID: Int, agencyName: String) -> JoinAgencyVC {
    let vc = JoinAgencyVC()
    
    let usecase = DIContainer.shared
      .resolve(type: ConfirmCertificateCodeUseCaseInterface.self)
    
    vc.reactor = JoinAgencyReactor(
      id: agencyID,
      name: agencyName,
      confirmCertificateCodeUseCase: usecase
    )
    return vc
  }
  
  func makeJoinComplete() -> JoinCompleteVC {
    let vc = JoinCompleteVC()
    vc.reactor = JoinCompleteReactor()
    return vc
  }
  
  func makeCreateComplete(id: Int) -> CreateCompleteVC {
    let vc = CreateCompleteVC()
    vc.reactor = CreateCompleteReactor(
      updateSelectedAgencyUseCase: DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
      id: id
    )
    return vc
  }
  
  func makeInputAgencyInfo(universityType: UniversityType) -> InputAgencyInfoVC {
    let vc = InputAgencyInfoVC()
    vc.reactor = InputAgencyInfoReactor(
      universityType: universityType,
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self),
      registerAgencyUseCase: DIContainer.shared.resolve(type: RegisterUniversitiesUseCaseInterface.self)
    )
    return vc
  }
  
  func makeInputUniversityInfo(agencyName: String, agencyType: AgencyType) -> InputUniversityInfoVC {
    let vc = InputUniversityInfoVC()
    vc.reactor = InputUniversityInfoReactor(
      agencyName: agencyName,
      agencyType: agencyType,
      registerUniversitiesUseCase: DIContainer.shared.resolve(type: RegisterUniversitiesUseCaseInterface.self),
      searchUniversitiesUseCase: DIContainer.shared.resolve(type: SearchUniversitiesUseCaseInterface.self),
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self)
    )
    return vc
  }
}
