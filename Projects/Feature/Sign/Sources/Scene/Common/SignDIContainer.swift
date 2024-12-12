import UIKit

import Core
import CreateAgencyInterface

public final class SignDIContainer {
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae
  
  private let inputAgencyInfoFactory: InputAgencyInfoFactoryInterface

  public init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae,
    inputAgencyInfoFactory: InputAgencyInfoFactoryInterface
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
    self.inputAgencyInfoFactory = inputAgencyInfoFactory
  }

  func splash(with coordinator: SignCoordinator) -> SplashVC {
    let vc = SplashVC()
    let signRepository = SignRepository(
      networkManager: networkManager,
      localStorage: localStorage,
      kakaoAuthManager: KakaoAuthManager(),
      appleAuthManager: AppleAuthManager()
    )
    let versionRepository = VersionRepository(networkManager: networkManager)
    vc.reactor = SplashReactor(
      signRepository: signRepository,
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage),
      versionRepo: versionRepository
    )
    vc.coordinator = coordinator
    return vc
  }

  func login(with coordinator: SignCoordinator) -> LoginVC {
    let vc = LoginVC()
    let signRepository = SignRepository(
      networkManager: networkManager,
      localStorage: localStorage,
      kakaoAuthManager: KakaoAuthManager(),
      appleAuthManager: AppleAuthManager()
    )
    vc.coordinator = coordinator
    vc.reactor = LoginReactor(
      signRepository: signRepository,
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage)
    )
    return vc
  }

  func createAgency(with coordinator: SignCoordinator) -> UIViewController {
    let vc = inputAgencyInfoFactory.make()
    return vc
  }

  func congratulations(with coordinator: SignCoordinator) -> CongratulationsVC {
    let vc = CongratulationsVC()
    vc.reactor = CongratulationsReactor()
    vc.coordinator = coordinator
    return vc
  }
}
