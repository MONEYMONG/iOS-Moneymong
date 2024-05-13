import UIKit

import LocalStorage
import NetworkService
import BaseFeature

public final class LedgerDIContainer {
  private let localStorage: LocalStorageInterface
  private let networkManager: NetworkManagerInterfacae
  private let globalService: LedgerGlobalServiceInterface = LedgerGlobalService()
  
  public init(localStorage: LocalStorageInterface, networkManager: NetworkManagerInterfacae) {
    self.localStorage = localStorage
    self.networkManager = networkManager
  }
  
  func ledger(with coordinator: LedgerCoordinator) -> LedgerVC {
    let vc = LedgerVC(
      [
        ledgerTab(with: coordinator),
        memberTab()
      ]
    )
    vc.reactor = LedgerReactor(
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage),
      agencyRepo: AgencyRepository(networkManager: networkManager),
      globalService: globalService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  private func ledgerTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = LedgerTabVC()
    vc.title = "장부"
    vc.reactor = LedgerTabReactor()
    vc.coordinator = coordinator
    return vc
  }
  
  private func memberTab() -> UIViewController {
    let vc = MemberTabVC()
    vc.title = "멤버"
    vc.reactor = MemberTabReactor(
      userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage),
      agencyRepo: AgencyRepository(networkManager: networkManager),
      globalService: globalService
    )
    return vc
  }
  
  func manualInput(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let manualInputCoordinator = ManualInputCoordinator(
      navigationController: vc,
      diContainer: ManualInputDIContainer()
    )
    coordinator.childCoordinators.append(manualInputCoordinator)
    manualInputCoordinator.parentCoordinator = coordinator
    manualInputCoordinator.start(animated: false)
    return vc
  }
}
