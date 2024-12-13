import UIKit

public protocol InputUniversityInfoFactoryInterface {
  func make(coordinator: CreateAgencyCoordinator?, agencyName: String, agencyType: AgencyType) -> UIViewController
}
