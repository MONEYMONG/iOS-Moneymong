import MainFeature
import SignFeature
import AgencyFeature

final class AppDIContainer {
  let signDIContainer: SignDIContainer
  let mainDIContainer: MainDIContainer

  init() {
    self.signDIContainer = SignDIContainer()
    self.mainDIContainer = MainDIContainer(
      agencyContainer: AgencyDIContainer()
    )
  }
}
