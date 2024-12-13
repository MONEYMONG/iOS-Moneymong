import UIKit

public protocol CreateCompleteFactoryInterface {
  func make(coordinator: CreateAgencyCoordinator, id: Int) -> UIViewController
}
