import NetworkService
import LocalStorage

public final class MyPageDIContainer {
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae

  private let userRepo: UserRepositoryInterface
  
  public init(
    localStorage: LocalStorageInterface,
    networkManager: NetworkManagerInterfacae
  ) {
    self.localStorage = localStorage
    self.networkManager = networkManager
    self.userRepo = UserRepository(networkManager: networkManager)
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
