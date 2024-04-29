import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature

import NetworkService

final class AppDIContainer {
  let signDIContainer: SignDIContainer
  let mainDIContainer: MainDIContainer
  
  let userRepo: UserRepositoryInterface
  
  init(
    userRepo: UserRepositoryInterface = UserRepository()
  ) {
    self.userRepo = userRepo
    
    self.signDIContainer = SignDIContainer()
    self.mainDIContainer = MainDIContainer(
      agencyContainer: .init(),
      myPageContainer: .init(userRepo: userRepo),
      ledgerContainer: .init()
    )
  }
}
