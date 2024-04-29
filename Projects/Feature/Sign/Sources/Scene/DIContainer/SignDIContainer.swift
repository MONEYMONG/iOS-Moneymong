import NetworkService
import LocalStorage

public final class SignDIContainer {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  public init(
    networkManager: NetworkManagerInterfacae = NetworkManager(),
    localStorage: LocalStorageInterface = LocalStorageManager()
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }

  func splash(with coordinator: SignCoordinator) -> SplashVC {
    let vc = SplashVC()
    vc.reactor = SplashReactor()
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
    let universityRepository = UniversityRepository(networkManager: networkManager)
    vc.reactor = LoginReactor(
      signRepository: signRepository,
      universityRepository: universityRepository
    )
    vc.coordinator = coordinator
    return vc
  }
}
