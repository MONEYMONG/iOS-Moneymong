import UIKit

import AgencyInterface
import AgencyFeatureInterface
import AuthInterface
import BaseFeature
import UserInterface

struct AgencyFactory {
  
  init() { }
  
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
  
  func makeInputAgencyInfo() -> InputAgencyInfoVC {
    let vc = InputAgencyInfoVC()
    vc.reactor = InputAgencyInfoReactor(
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self),
      deleteUserUseCase: DIContainer.shared.resolve(type: DeleteUserUseCaseInterface.self)
    )
    return vc
  }
}
