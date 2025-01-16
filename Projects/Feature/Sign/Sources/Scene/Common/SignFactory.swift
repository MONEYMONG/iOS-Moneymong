import UIKit

import SignFeatureInterface
import AuthInterface
import BaseFeature

public struct SignFactory: SignFactoryInterface {
  public init() {}
  
  public func makeSplash() -> UIViewController {
    let vc = SplashVC()
    vc.reactor = SplashReactor(autoSignUseCase: DIContainer.shared.resolve(type: AutoSignUseCaseInterface.self))
    return vc
  }
  
  public func makeLogin() -> UIViewController {
    let vc = LoginVC()
    vc.reactor = LoginReactor(
      signUpUseCase: DIContainer.shared.resolve(type: SignUpUseCaseInterface.self),
      getRecentLoginInfoUseCase: DIContainer.shared.resolve(type: GetRecentLoginInfoUseCaseInterface.self)
    )
    return vc
  }
  
  public func makeCongratulation() -> UIViewController {
    let vc = CongratulationsVC()
    vc.reactor = CongratulationsReactor()
    return vc
  }
}
