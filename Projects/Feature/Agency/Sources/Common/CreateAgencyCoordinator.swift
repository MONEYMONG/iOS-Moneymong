import UIKit

import AgencyFeatureInterface
import BaseFeature

public final class CreateAgencyCoordinator: Coordinator {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
    
  public init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }

  public func start(animated: Bool, universityType: UniversityType) {
#warning("TODO")
    //let vc = DIContainer.shared.resolve(type: InputAgencyInfoFactoryInterface.self).make(coordinator: self, universityType: universityType)
   // navigationController?.viewControllers = [vc]
  }
  
  public func move(to scene: Scene) {
    switch scene {
    case .main:
      parentCoordinator?.move(to: .main)
    case .ledger:
      parentCoordinator?.move(to: .ledger)
    case let .createManualLedger(id):
      parentCoordinator?.move(to: .createManualLedger(id))
    default: break
    }
  }
}
