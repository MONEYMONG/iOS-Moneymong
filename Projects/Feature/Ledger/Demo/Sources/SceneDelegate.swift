import UIKit

import LedgerFeature
import LedgerFeatureInterface
import DesignSystem
import BaseFeature
import AgencyFeatureInterface
import AgencyFeature
import AgencyInterface
import AgencyTesting
import LedgerInterface
import UserInterface
import LedgerTesting
import UserTesting
import AuthInterface
import AuthTesting

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var coordinator: LedgerCoordinator?
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let contentFormatter = ContentFormatter()
    Fonts.registerFont()
    registerDependency(contentFormatter: contentFormatter)
    let navigationController = UINavigationController()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    coordinator = LedgerCoordinator(
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
  func registerDependency(
    contentFormatter: ContentFormatter
  ) {
    // MARK: Common
    DIContainer.shared.register(type: ContentFormatter.self) {
      return ContentFormatter()
    }
    
    DIContainer.shared.register(type: LedgerServiceInterface.self) {
      return LedgerService()
    }
    
    // MARK: LedgerTab
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
    
    DIContainer.shared.register(type: ChangeMemberRoleUseCaseInterface.self) {
      return MockChangeMemberRoleUseCase()
    }
    
    //MARK: LedgerMain
    DIContainer.shared.register(type: GetMyAgencyUseCaseInterface.self) {
      return MockGetMyAgencyUseCase()
    }
    
    DIContainer.shared.register(type: UpdateSelectedAgencyUseCaseInterface.self) {
      return MockUpdateSelectedAgencyUseCase()
    }
    
    //MARK: Creater
    DIContainer.shared.register(type: CreateManualLedgerCoordinatorInterface.self) {
      return CreateManualLedgerCoordinator(
        contentFormatter: contentFormatter
      )
    }
    
    DIContainer.shared.register(type: DeleteImageUseCaseInterface.self) {
      return MockDeleteImageUseCase()
    }
    
    DIContainer.shared.register(type: CreateLedgerUseCaseInterface.self) {
      return MockCreateLedgerUseCase()
    }
    
    DIContainer.shared.register(type: UploadImageUseCaseInterface.self) {
      return MockUploadImageUseCase()
    }
    
    DIContainer.shared.register(type: GetCategoriesUseCaseInterface.self) {
      return MockGetCategoriesUseCase()
    }
    
    DIContainer.shared.register(type: DeleteCategoryUseCaseInterface.self) {
      return MockDeleteCategoryUseCase()
    }
    
    DIContainer.shared.register(type: CreateCategoryUseCaseInterface.self) {
      return MockCreateCategoryUseCase()
    }
    
    // MARK: - Detail
    DIContainer.shared.register(type: UpdateLedgerUseCaseInterface.self) {
      return MockUpdateLedgerUseCase()
    }
    
    DIContainer.shared.register(type: UploadDocumentUseCaseInterface.self) {
      return MockUploadDocumentUseCase()
    }
    
    DIContainer.shared.register(type: DeleteDocumentUseCaseInterface.self) {
      return MockDeleteDocumentUseCase()
    }
    
    DIContainer.shared.register(type: GetLedgerDetailUseCaseInterface.self) {
      return MockGetLedgerDetailUseCase()
    }
    
    DIContainer.shared.register(type: DeleteLedgerUseCaseInterface.self) {
      return MockDeleteLedgerUseCase()
    }
    
    //MARK: - CreateAgency
    DIContainer.shared.register(type: CreateAgencyCoordinatorInterface.self) {
      return CreateAgencyCoordinator()
    }
    
    DIContainer.shared.register(type: CreateAgencyUseCaseInterface.self) {
      return MockCreateAgencyUseCase()
    }
    
    DIContainer.shared.register(type: DeleteUserUseCaseInterface.self) {
      return MockDeleteUserUseCase()
    }
    
    DIContainer.shared.register(type: UpdateSelectedAgencyUseCaseInterface.self) {
      return MockUpdateSelectedAgencyUseCase()
    }
    
    //MARK: - JoinAgency
    DIContainer.shared.register(type: JoinAgencyCoordinatorInterface.self) {
      return JoinAgencyCoordinator()
    }
    
    DIContainer.shared.register(type: ConfirmCertificateCodeUseCaseInterface.self) {
      return MockConfirmCertificateCodeUseCase()
    }
    
    //MARK: - Report
    
    DIContainer.shared.register(type: GetReportUseCaseInterface.self) {
      return MockGetReportUseCase()
    }
  }
}
