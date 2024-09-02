import UIKit
import SwiftUI

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
  
  enum Scene {
    case alert(title: String, subTitle: String, okAction: () -> Void)
    case web(urlString: String)
    case withrawal
    case debug
  }
  
  public func start(animated: Bool) {
    myPage(animated: animated)
  }
  
  func present(_ scene: Scene, animated: Bool = true) {
    switch scene {
    case let .alert(title, subTitle, action): 
      alert(title: title, subTitle: subTitle, okAction: action)
    case let .web(urlString):
      web(urlString: urlString)
    case .withrawal:
      withdrawl()
    case .debug:
      debug()
    }
  }
  
  func goLogin() {
    parentCoordinator?.move(to: .login)
    remove()
  }
  
  func pop(animated: Bool = true) {
    navigationController.popViewController(animated: animated)
  }
  
  deinit {
    print(#function)
  }
}

extension MyPageCoordinator {
  private func myPage(animated: Bool) {
    let vc = diContainer.myPage(with: self)
    navigationController.setViewControllers([vc], animated: true)
  }
  
  private func withdrawl(animated: Bool = true) {
    let vc = diContainer.withDrawl(with: self)
    navigationController.pushViewController(vc, animated: animated)
  }
  
  private func alert(title: String, subTitle: String, okAction: @escaping () -> Void) {
    AlertsManager.show(title: title, subTitle: subTitle, type: .default(okAction: okAction))
  }
  
  private func debug(animated: Bool = true) {
    navigationController.pushViewController(UIHostingController(rootView: PulseView()), animated: animated)
  }
}
