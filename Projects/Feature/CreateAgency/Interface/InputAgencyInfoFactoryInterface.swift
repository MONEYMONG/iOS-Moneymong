import UIKit

public protocol InputAgencyInfoFactoryInterface {
  func make(coordinator: CreateAgencyCoordinator?, universityType: UniversityType) -> UIViewController
}
