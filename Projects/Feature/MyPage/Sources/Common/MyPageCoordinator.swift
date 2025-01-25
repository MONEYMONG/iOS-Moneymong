import UIKit
import SwiftUI

import BaseFeature
import DesignSystem
import MyPageFeatureInterface

public final class MyPageCoordinator: Coordinator {
  public var navigationController: UINavigationController
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
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
      //debug()
      break
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
    debugPrint(#function)
  }
}

extension MyPageCoordinator {
  private func myPage(animated: Bool) {
    guard let vc = DIContainer.shared.resolve(type: MyPageFactoryInterface.self).makeMyPageVC() as? MyPageVC else { return }
    vc.coordinator = self
    navigationController.setViewControllers([vc], animated: true)
  }
  
  private func withdrawl(animated: Bool = true) {
    guard let vc = DIContainer.shared.resolve(type: MyPageFactoryInterface.self).makeWithdrawalVC() as? WithdrawalVC else { return }
    vc.coordinator = self
    navigationController.pushViewController(vc, animated: animated)
  }
  
  private func alert(title: String, subTitle: String, okAction: @escaping () -> Void) {
    AlertsManager.show(title: title, subTitle: subTitle, type: .default(okAction: okAction))
  }
}
