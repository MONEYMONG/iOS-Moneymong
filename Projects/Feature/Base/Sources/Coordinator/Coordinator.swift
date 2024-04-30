import UIKit

public enum Scene {
  case main
  case login
}

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }

  func start(animated: Bool)
  func remove() // 자기자신을 부모의 childCoordinators 스택에서 제거
  func move(to scene: Scene) // 특정 화면으로 이동 (부모에게 요청)
}

public extension Coordinator {
  func remove() {
    parentCoordinator?.childCoordinators.removeAll { $0 === self }
  }

  func move(to scene: Scene) {
    // empty
  }
}
