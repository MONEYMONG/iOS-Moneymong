import UIKit

import BaseFeature
import CreateAgencyInterface
import AgencyInterface
import UserInterface

public struct InputAgencyInfoFactory: InputAgencyInfoFactoryInterface {
  public init() {}
  
  public func make(coordinator: CreateAgencyCoordinator?, universityType: UniversityType) -> UIViewController {
    let vc = InputAgencyInfoVC(
      createCompleteFactory: DIContainer.shared.resolve(type: CreateCompleteFactoryInterface.self),
      inputUniversityInfoFactory: DIContainer.shared.resolve(type: InputUniversityInfoFactoryInterface.self)
    )
    vc.coordinator = coordinator
    vc.reactor = InputAgencyInfoReactor(
      universityType: universityType,
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self),
      registerAgencyUseCase: DIContainer.shared.resolve(type: RegisterUniversitiesUseCaseInterface.self)
    )
    return vc
  }
}
