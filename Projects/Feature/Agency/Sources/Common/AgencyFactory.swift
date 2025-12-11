import UIKit

import AgencyInterface
import AgencyFeatureInterface
import AuthInterface
import BaseFeature
import UserInterface
import LedgerFeatureInterface

struct AgencyFactory {
  
  init() { }
  
  func makeJoinAgency(navigationType: NavigationType = .present) -> JoinAgencyVC {
    let vc = JoinAgencyVC(navigationType: navigationType)
    vc.reactor = JoinAgencyReactor(
      confirmCertificateCodeUseCase: DIContainer.shared.resolve(type: ConfirmCertificateCodeUseCaseInterface.self),
      ledgerService: DIContainer.shared.resolve(type: LedgerServiceInterface.self)
    )
    return vc
  }
  
  func makeInputAgencyInfo() -> InputAgencyInfoVC {
    let vc = InputAgencyInfoVC()
    vc.reactor = InputAgencyInfoReactor(
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self),
      deleteUserUseCase: DIContainer.shared.resolve(type: DeleteUserUseCaseInterface.self),
      ledgerService: DIContainer.shared.resolve(type: LedgerServiceInterface.self)
    )
    return vc
  }
}
