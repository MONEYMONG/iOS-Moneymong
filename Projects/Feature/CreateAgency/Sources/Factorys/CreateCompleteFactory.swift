import UIKit

import Core
import CreateAgencyInterface

public struct CreateCompleteFactory: CreateCompleteFactoryInterface {
  
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface
  
  public init(networkManager: NetworkManagerInterfacae, localStorage: LocalStorageInterface) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }
  
  public func make(coordinator: CreateAgencyCoordinator?, id: Int) -> UIViewController {
    let vc = CreateCompleteVC()
    vc.coordinator = coordinator
    vc.reactor = CreateCompleteReactor(userRepo: UserRepository(networkManager: networkManager, localStorage: localStorage), id: id)
    
    return vc
  }
}
