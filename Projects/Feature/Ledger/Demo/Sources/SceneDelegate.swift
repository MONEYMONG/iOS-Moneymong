import UIKit

import LedgerFeature
import DesignSystem
import BaseFeature
import AgencyInterface
import LedgerInterface
import UserInterface
import AgencyTesting
import LedgerTesting
import UserTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var coordinator: LedgerCoordinator?
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    Fonts.registerFont()
    registerDependency()
    let navigationController = UINavigationController()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let ledgerService = LedgerService()
    let contentFormatter = ContentFormatter()
    coordinator = LedgerCoordinator(
      ledgerService: ledgerService,
      contentFormatter: contentFormatter
    )
    coordinator?.navigationController = navigationController
    coordinator?.start(animated: false)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
  // MARK: LedgerTab
  func registerDependency() {
    DIContainer.shared.register(type: GetLedgerDateRangeUseCaseInterface.self) {
      return MockGetLedgerDateRangeUseCase()
    }
    
    DIContainer.shared.register(type: GetUserIDUseCaseInterface.self) {
      return MockGetUserIDUseCase()
    }
    
    DIContainer.shared.register(type: SaveLedgerDateRangeUseCaseInterface.self) {
      return MockSaveLedgerDateRangeUseCase()
    }
    
    DIContainer.shared.register(type: GetLedgerListUseCaseInterface.self) {
      return MockGetLedgerListUseCase()
    }
    
    DIContainer.shared.register(type: GetMemberListUseCaseInterface.self) {
      return MockGetMemberListUseCase()
    }
    
    // MARK: MemberTab
    DIContainer.shared.register(type: GetSelectedAgencyUseCaseInterface.self) {
      return MockGetSelectedAgencyUseCase()
    }
    
    DIContainer.shared.register(type: ReissueCodeUseCaseInterface.self) {
      return MockReissueCodeUseCase()
    }
    
    DIContainer.shared.register(type: KickoutMemberUseCaseInterface.self) {
      return MockKickoutMemberUseCase()
    }
    
    DIContainer.shared.register(type: DeleteAgencyUseCaseInterface.self) {
      return MockDeleteAgencyUseCase()
    }
    
    DIContainer.shared.register(type: GetMyInfoUseCaseInterface.self) {
      return MockGetMyInfoUseCase()
    }
    
    DIContainer.shared.register(type: GetInvitationCodeUseCaseInterface.self) {
      return MockGetInvitationCodeUseCase()
    }
    
    //MARK: LedgerMain
    DIContainer.shared.register(type: GetMyAgencyUseCaseInterface.self) {
      return MockGetMyAgencyUseCase()
    }
    
    DIContainer.shared.register(type: UpdateSelectedAgencyUseCaseInterface.self) {
      return MockUpdateSelectedAgencyUseCase()
    }
  }
}
