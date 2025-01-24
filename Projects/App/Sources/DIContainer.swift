import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature
import CreateAgency

import Core

final class AppDIContainer {
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
  }
}
