import UIKit

import CreateAgencyInterface

public struct CreateCompleteFactory: CreateCompleteFactoryInterface {
  
  public init() {}
  
  public func make() -> UIViewController {
    let vc = CreateCompleteVC()
    
    return vc
  }
}
