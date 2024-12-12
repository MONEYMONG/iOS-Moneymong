import UIKit

import CreateAgencyInterface

public struct InputUniversityInfoFactory: InputUniversityInfoFactoryInterface {
  
  public init() {}
  
  public func make() -> UIViewController {
    let vc = InputUniversityInfoVC()
    
    return vc
  }
}
