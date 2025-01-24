import UIKit

public protocol InputAgencyInfoFactoryInterface {
  func make(universityType: UniversityType) -> UIViewController
}
