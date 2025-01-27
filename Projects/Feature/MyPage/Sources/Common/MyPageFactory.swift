import UIKit

import AuthInterface
import BaseFeature
import UserInterface

struct MyPageFactory {
  func makeMyPageVC() -> MyPageVC {
    let vc = MyPageVC()
    let getMyInfoUseCase = DIContainer.shared.resolve(type: GetMyInfoUseCaseInterface.self)
    let logoutUseCase = DIContainer.shared.resolve(type: LogoutUseCaseInterface.self)
    vc.reactor = MyPageReactor(
      getMyInfoUseCase: getMyInfoUseCase,
      logoutUseCase: logoutUseCase
    )
    return vc
  }
  
  func makeWithdrawalVC() -> WithdrawalVC {
    let vc = WithdrawalVC()
    let deleteUserUseCase = DIContainer.shared.resolve(type: DeleteUserUseCaseInterface.self)
    vc.reactor = WithdrawalReactor(deleteUserUseCase: deleteUserUseCase)
    return vc
  }
}
