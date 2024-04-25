import NetworkService
import LocalStorage

public final class SignDIContainer {
  private let appleAuthManager: AppleAuthManager
  private let kakaoAuthManager: KakaoAuthManager
  private let localStorage: LocalStorageInterface
  private let signRepository: SignRepositoryInterface

  public init(
    appleAuthManager: AppleAuthManager = AppleAuthManager(),
    kakaoAuthManager: KakaoAuthManager = KakaoAuthManager.shared,
    localStorage: LocalStorageInterface = LocalStorageManager(),
    signRepository: SignRepositoryInterface = SignRepository()
  ) {
    self.appleAuthManager = appleAuthManager
    self.kakaoAuthManager = kakaoAuthManager
    self.localStorage = localStorage
    self.signRepository = signRepository
  }

  func splash(with coordinator: SignCoordinator) -> SplashVC {
    let vc = SplashVC()
    vc.reactor = SplashReactor()
    vc.coordinator = coordinator
    return vc
  }

  func login(with coordinator: SignCoordinator) -> LoginVC {
    let vc = LoginVC()
    vc.reactor = LoginReactor(
      appleAuthManager: appleAuthManager,
      kakaoAuthManager: kakaoAuthManager,
      localStorage: localStorage,
      signRepository: signRepository
    )
    vc.coordinator = coordinator
    return vc
  }
}
