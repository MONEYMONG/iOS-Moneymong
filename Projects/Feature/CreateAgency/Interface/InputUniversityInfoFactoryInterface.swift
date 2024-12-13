import UIKit

public protocol InputUniversityInfoFactoryInterface {
  func make(agencyName: String, agencyType: AgencyType) -> UIViewController
}
