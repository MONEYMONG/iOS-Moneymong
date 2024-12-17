import UIKit

import BaseFeatureInterface

public final class CreateAgencyCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  
  private let inputAgencyFactory: InputAgencyInfoFactoryInterface
  
  public init(
    navigationController: UINavigationController,
    inputAgencyFactory: InputAgencyInfoFactoryInterface
  ) {
    self.navigationController = navigationController
    self.inputAgencyFactory = inputAgencyFactory
  }

  public func start(animated: Bool, universityType: UniversityType) {
    let vc = inputAgencyFactory.make(coordinator: self, universityType: universityType)
    navigationController.viewControllers = [vc]
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
