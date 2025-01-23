import UIKit

import AgencyInterface

public protocol AgencyFactoryInterface {
  func makeAgencyList() -> UIViewController
  func makeJoinAgency(agencyID: Int, agencyName: String) -> UIViewController
  func makeJoinComplete() -> UIViewController
}
