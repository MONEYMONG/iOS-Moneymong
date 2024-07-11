import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature

import Core

final class AppDIContainer {

  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae
  private let tokenIntercepter: TokenRequestIntercepter

  let signDIContainer: SignDIContainer
  let mainDIContainer: MainDIContainer

  init() {
    self.localStorage = LocalStorage()
    self.networkManager = NetworkManager()
    
    self.tokenIntercepter = TokenRequestIntercepter(
      localStorage: localStorage,
      tokenRepository: TokenRepository(
        networkManager: networkManager,
        localStorage: localStorage
      )
    )
    
    (networkManager as? NetworkManager)?.tokenIntercepter = tokenIntercepter

    self.signDIContainer = SignDIContainer(
      localStorage: localStorage,
      networkManager: networkManager
    )
    
    self.mainDIContainer = MainDIContainer(
      localStorage: localStorage,
      networkManager: networkManager
    )
  }
}
