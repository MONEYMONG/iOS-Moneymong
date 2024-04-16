import UIKit

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }

  func start(animated: Bool)
  func childDidFinish(_ child: Coordinator?)
  func coordinatorDidFinish()
}

public extension Coordinator {
  func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: index)
        break
      }
    }
  }

  func coordinatorDidFinish() {}
}
