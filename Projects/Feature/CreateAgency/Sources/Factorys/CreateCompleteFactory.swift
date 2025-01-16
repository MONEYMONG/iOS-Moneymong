import UIKit

import BaseFeature
import CreateAgencyInterface
import UserInterface

public struct CreateCompleteFactory: CreateCompleteFactoryInterface {
  public init() {}
  
  public func make(coordinator: CreateAgencyCoordinator?, id: Int) -> UIViewController {
    let vc = CreateCompleteVC()
    vc.coordinator = coordinator
    vc.reactor = CreateCompleteReactor(
      updateSelectedAgencyUseCase: DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
      id: id
    )
    return vc
  }
}
