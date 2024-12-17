import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature
import CreateAgency

import Core

final class AppDIContainer {
  let signDIContainer: SignDIContainer
  let mainDIContainer: MainDIContainer

  init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae
  ) {
    
    (networkManager as? NetworkManager)?.tokenIntercepter = TokenRequestIntercepter(
      localStorage: localStorage,
      tokenRepository: TokenRepository(
        networkManager: networkManager,
        localStorage: localStorage
      )
    )

    self.signDIContainer = SignDIContainer(
      localStorage: localStorage,
      networkManager: networkManager,
      inputAgencyInfoFactory: InputAgencyInfoFactory(networkManager: networkManager, localStorage: localStorage)
    )
    
    self.mainDIContainer = MainDIContainer(
      localStorage: localStorage,
      networkManager: networkManager,
      inputAgencyInfoFactory: InputAgencyInfoFactory(networkManager: networkManager, localStorage: localStorage)
    )
  }
}
