import UIKit

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var diContainer: DIContainerInterface { get }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }

  func start(animated: Bool)
  func addChild(_ child: Coordinator?)
  func childDidFinish(_ child: Coordinator?)
}

public extension Coordinator {
  func addChild(_ child: Coordinator?) {
    if let _child = child {
      childCoordinators.append(_child)
    }
  }

  func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}
