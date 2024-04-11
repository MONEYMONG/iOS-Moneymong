import BaseFeature
import SignFeatureInterface
import AgencyFeatureInterface
import LedgerFeatureInterface
import MainFeatureInterface

final class DIContainer: DIContainerInterface {
  var signDIContainer: DIContainerInterface
  var agencyDIContainer: DIContainerInterface
  var ledgerDIContainer: DIContainerInterface
  var myPageDIContainer: DIContainerInterface

  init(
    signDIContainer: DIContainerInterface,
    agencyDIContainer: AgencyDIContainerInterface,
    ledgerDIContainer: DIContainerInterface,
    myPageDIContainer: DIContainerInterface
  ) {
    self.signDIContainer = signDIContainer
    self.agencyDIContainer = agencyDIContainer
    self.ledgerDIContainer = ledgerDIContainer
    self.myPageDIContainer = myPageDIContainer
  }
}
