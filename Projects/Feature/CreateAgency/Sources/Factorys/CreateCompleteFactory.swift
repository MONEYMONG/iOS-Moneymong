import UIKit

import BaseFeature
import CreateAgencyInterface
import UserInterface

public struct CreateCompleteFactory: CreateCompleteFactoryInterface {
  public init() {}
  
  public func make(id: Int) -> UIViewController {
    let vc = CreateCompleteVC()
    vc.reactor = CreateCompleteReactor(
      updateSelectedAgencyUseCase: DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
      id: id
    )
    return vc
  }
}
