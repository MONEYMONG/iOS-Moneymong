import UIKit
import SafariServices

import BaseFeature
import DesignSystem

public final class MyPageCoordinator: Coordinator {
  public var navigationController: UINavigationController
  private let diContainer: MyPageDIContainer
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []

  public init(navigationController: UINavigationController, diContainer: MyPageDIContainer) {
    self.navigationController = navigationController
    self.diContainer = diContainer
  }

  public func start(animated: Bool) {
    myPage(animated: animated)
  }
  
  func presentWeb(urlString: String) {
    guard let url = URL(string: urlString) else {
      return debugPrint("Invalid URL", #function)
    }
    let vc = SFSafariViewController(url: url)
    navigationController.present(vc, animated: true)
  }
  
  func presentAlert(title: String, subTitle: String, okAction: @escaping () -> Void) {
    AlertsManager.show(navigationController, title: title, subTitle: subTitle, okAction: okAction, cancelAction: { })
  }
}

extension MyPageCoordinator {
  private func myPage(animated: Bool) {
    let vc = diContainer.myPage(with: self)
    navigationController.setViewControllers([vc], animated: true)
  }
}
