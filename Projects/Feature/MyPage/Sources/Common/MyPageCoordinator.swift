import UIKit
import SwiftUI

import BaseFeature
import DesignSystem
import MyPageFeatureInterface

public final class MyPageCoordinator: MyPageCoordinatorInterface {
  public weak var navigationController: UINavigationController?
  public weak var parentCoordinator: Coordinator?

  public init() {}
  
  enum Scene {
    case alert(title: String, subTitle: String?, okAction: () -> Void)
    case web(urlString: String)
    case withrawal
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
    }
  }
  
  func pop(animated: Bool = true) {
    navigationController?.popViewController(animated: animated)
  }
}

extension MyPageCoordinator {
  private func myPage(animated: Bool) {
    let vc = MyPageFactory().makeMyPageVC()
    vc.coordinator = self
    navigationController?.setViewControllers([vc], animated: true)
  }
  
  private func withdrawl(animated: Bool = true) {
    let vc = MyPageFactory().makeWithdrawalVC()
    vc.coordinator = self
    navigationController?.pushViewController(vc, animated: animated)
  }
  
  private func alert(title: String, subTitle: String?, okAction: @escaping () -> Void) {
    AlertsManager.show(title: title, subTitle: subTitle, type: .default(okAction: okAction))
  }
}
