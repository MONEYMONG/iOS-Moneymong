import Core

public final class SignDIContainer {
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae

  public init(
    localStorage: LocalStorageInterface = LocalStorage(),
    networkManager: NetworkManagerInterfacae = NetworkManager()
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
  }

  func splash(with coordinator: SignCoordinator) -> SplashVC {
    let vc = SplashVC()
    let signRepository = SignRepository(
      networkManager: networkManager,
      localStorage: localStorage,
      kakaoAuthManager: KakaoAuthManager(),
      appleAuthManager: AppleAuthManager()
    )
    vc.reactor = SplashReactor(
      signRepository: signRepository,
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage)
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

  func signUp(with coordinator: SignCoordinator) -> SignUpVC {
    let vc = SignUpVC()
    let universityRepository = UniversityRepository(networkManager: networkManager)
    vc.reactor = SignUpReactor(universityRepository: universityRepository)
    vc.coordinator = coordinator
    return vc
  }

  func congratulations(with coordinator: SignCoordinator) -> CongratulationsVC {
    let vc = CongratulationsVC()
    vc.reactor = CongratulationsReactor()
    vc.coordinator = coordinator
    return vc
  }
}
