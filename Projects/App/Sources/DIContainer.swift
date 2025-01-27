import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature

import Core

final class AppDIContainer {
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
    
    self.mainDIContainer = MainDIContainer(
      localStorage: localStorage,
      networkManager: networkManager
    )
  }
}
