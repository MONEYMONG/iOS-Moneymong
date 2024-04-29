import NetworkService

public final class MyPageDIContainer {
  private let userRepo: UserRepositoryInterface
  
  public init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }

  func myPage(with coordinator: MyPageCoordinator) -> MyPageVC {
    let vc = MyPageVC()
    vc.reactor = MyPageReactor(userRepo: userRepo)
    vc.coordinator = coordinator
    return vc
  }
  
  func withDrawl(with coordinator: MyPageCoordinator) -> WithdrawalVC {
    let vc = WithdrawalVC()
    vc.reactor = WithdrawalReactor(userRepo: userRepo)
    vc.coordinator = coordinator
    return vc
  }
}
