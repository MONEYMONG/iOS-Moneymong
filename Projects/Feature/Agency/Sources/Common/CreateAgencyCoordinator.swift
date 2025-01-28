import UIKit

import AgencyFeatureInterface
import BaseFeature

public final class CreateAgencyCoordinator: CreateAgencyCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?
  
  public init() { }
  
  enum Destination {
    case inputUniversity(agencyName: String, agencyType: AgencyType)
    case createComplete(agencyID: Int)
  }

  public func start(universityType: UniversityType, animated: Bool) {
    inputAgencyInfo(universityType, animated: animated)
  }
  
  func push(_ destination: Destination, animated: Bool = true) {
    switch destination {
    case let .inputUniversity(name, type):
      inputUniversityInfo(name, type, animated: animated)
    case let .createComplete(agencyID):
      createComplete(agencyID, animated: animated)
    }
  }
  
  func dismiss(animated: Bool = true) {
    navigationController?.topViewController?.dismiss(animated: animated)
  }
}

private extension CreateAgencyCoordinator {
  func inputAgencyInfo(_ universityType: UniversityType, animated: Bool) {
    let factory = AgencyFactory()
    let vc = factory.makeInputAgencyInfo(universityType: universityType)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func inputUniversityInfo(_ name: String, _ type: AgencyType, animated: Bool) {
    let factory = AgencyFactory()
    let vc = factory.makeInputUniversityInfo(agencyName: name, agencyType: type)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  func createComplete(_ agencyID: Int, animated: Bool) {
    let factory = AgencyFactory()
    let vc = factory.makeCreateComplete(id: agencyID)
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
}
