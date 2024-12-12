import UIKit

import CreateAgencyInterface

public struct InputAgencyInfoFactory: InputAgencyInfoFactoryInterface {
  
  public init() {}
  
  public func make() -> UIViewController {
    let vc = InputAgencyInfoVC(
      createCompleteFactory: CreateCompleteFactory(),
      inputUniversityInfoFactory: InputUniversityInfoFactory()
    )
    
    return vc
  }
}
