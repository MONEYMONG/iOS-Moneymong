import UIKit

import BaseFeature
import CreateAgencyInterface
import UserInterface
import AgencyInterface

public struct InputUniversityInfoFactory: InputUniversityInfoFactoryInterface {
  public init() {}
  
  public func make(coordinator: CreateAgencyCoordinator?, agencyName: String, agencyType: AgencyType) -> UIViewController {
    let vc = InputUniversityInfoVC(completeFactory: DIContainer.shared.resolve(type: CreateCompleteFactoryInterface.self))
    vc.coordinator = coordinator
    vc.reactor = InputUniversityInfoReactor(
      agencyName: agencyName,
      agencyType: agencyType,
      registerUniversitiesUseCase: DIContainer.shared.resolve(type: RegisterUniversitiesUseCaseInterface.self),
      searchUniversitiesUseCase: DIContainer.shared.resolve(type: SearchUniversitiesUseCaseInterface.self),
      createAgencyUseCase: DIContainer.shared.resolve(type: CreateAgencyUseCaseInterface.self)
    )
    return vc
  }
}
