import NetworkService

public final class SignDIContainer {
  private let signRepository: SignRepositoryInterface
  private let kakaoAuthManager: KakaoAuthManager

  public init(
    kakaoAuthManager: KakaoAuthManager = KakaoAuthManager.shared,
    signRepository: SignRepositoryInterface = SignRepository()
  ) {
    self.kakaoAuthManager = kakaoAuthManager
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
//    vc.reactor = LoginReactor(
//      kakaoAuthManager: kakaoAuthManager,
//      signRepository: signRepository
//    )
//    vc.coordinator = coordinator
    return vc
  }
}
