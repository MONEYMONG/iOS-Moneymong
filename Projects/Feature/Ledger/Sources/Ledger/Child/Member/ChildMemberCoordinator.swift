import UIKit

import BaseFeature

final class ChildMemberCoordinator: Coordinator {
  var navigationController: UINavigationController
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  private let diContainer: ChildMemberDIContainer

  
  init(
    navigationController: UINavigationController,
    diContainer: ChildMemberDIContainer
  ) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }
  
  func start(animated: Bool) {
    childMember(animated: false)
  }
}

extension ChildMemberCoordinator {
  private func childMember(animated: Bool) {
    let vc = diContainer.childMember(with: self)
    navigationController.title = "맴버"
    navigationController.viewControllers = [vc]
  }
}
