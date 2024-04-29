import NetworkService

public final class SignDIContainer {
  
  public init() {
    
  }

  func splash(with coordinator: SignCoordinator) -> SplashVC {
    let vc = SplashVC()
    vc.reactor = SplashReactor()
    vc.coordinator = coordinator
    return vc
  }

  func login(with coordinator: SignCoordinator) -> LoginVC {
    let vc = LoginVC()
    vc.reactor = LoginReactor()
    vc.coordinator = coordinator
    return vc
  }
}
