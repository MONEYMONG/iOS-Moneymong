import MainFeature
import SignFeature
import AgencyFeature
import LedgerFeature
import MyPageFeature

import NetworkService
import LocalStorage

final class AppDIContainer {

  private let localStorage = LocalStorageManager()
  private let networkManager: NetworkManagerInterfacae
  private let tokenIntercepter: TokenRequestIntercepter

  let signDIContainer: SignDIContainer
  let mainDIContainer: MainDIContainer

  init() {
    self.tokenIntercepter = TokenRequestIntercepter(
      localStorage: localStorage,
      tokenRepository: TokenRepository()
    )
    
    let networkManager = NetworkManager()
    networkManager.tokenIntercepter = tokenIntercepter
    self.networkManager = networkManager

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
