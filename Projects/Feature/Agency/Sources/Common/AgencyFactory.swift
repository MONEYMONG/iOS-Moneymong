import UIKit

import AgencyInterface
import AgencyFeatureInterface
import AuthInterface
import BaseFeature
import UserInterface
import LedgerFeatureInterface

struct AgencyFactory {
  
  init() { }
  
  func makeJoinAgency(navigationType: NavigationType = .present, ledgerService: LedgerServiceInterface?) -> JoinAgencyVC {
    let vc = JoinAgencyVC(navigationType: navigationType)
    vc.reactor = JoinAgencyReactor(
      confirmCertificateCodeUseCase: DIContainer.shared.resolve(type: ConfirmCertificateCodeUseCaseInterface.self), ledgerService: ledgerService
    )
    return vc
  }
  
  func makeInputAgencyInfo(ledgerService: LedgerServiceInterface?) -> InputAgencyInfoVC {
    let vc = InputAgencyInfoVC()
    vc.reactor = InputAgencyInfoReactor(
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self),
      deleteUserUseCase: DIContainer.shared.resolve(type: DeleteUserUseCaseInterface.self),
      ledgerService: ledgerService
    )
    return vc
  }
}
