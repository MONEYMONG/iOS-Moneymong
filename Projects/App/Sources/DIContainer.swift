import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature

final class AppDIContainer {
  let signDIContainer: SignDIContainer
  let mainDIContainer: MainDIContainer

  init() {
    self.signDIContainer = SignDIContainer()
    self.mainDIContainer = MainDIContainer(
      agencyContainer: AgencyDIContainer(),
      myPageContainer: MyPageDIContainer(
        userRepo: UserRepository()
      ),
      ledgerContainer: LedgerDIContainer()
    )
  }
}
