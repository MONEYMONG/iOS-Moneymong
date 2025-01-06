import UIKit

import AuthInterface
import BaseFeature
import UserInterface
import MyPageFeatureInterface

public struct MyPageFactory: MyPageFactoryInterface {
  
  public init(){}
  
  public func makeMyPageVC() -> UIViewController {
    let vc = MyPageVC()
    let getMyInfoUseCase = DIContainer.shared.resolve(type: GetMyInfoUseCaseInterface.self)
    let logoutUseCase = DIContainer.shared.resolve(type: LogoutUseCaseInterface.self)
    vc.reactor = MyPageReactor(
      getMyInfoUseCase: getMyInfoUseCase,
      logoutUseCase: logoutUseCase
    )
    return vc
  }
  
  public func makeWithdrawalVC() -> UIViewController {
    let vc = WithdrawalVC()
    let deleteUserUseCase = DIContainer.shared.resolve(type: DeleteUserUseCaseInterface.self)
    vc.reactor = WithdrawalReactor(deleteUserUseCase: deleteUserUseCase)
    return vc
  }
}
