import UIKit

import Auth
import AuthInterface
import Agency
import AgencyInterface
import AgencyFeature
import AgencyFeatureInterface
import BaseDomain
import BaseFeature
import DesignSystem
import Ledger
import LedgerInterface
import LedgerFeature
import LedgerFeatureInterface
import MyPageFeature
import MyPageFeatureInterface
import MMNetwork
import MMStorage
import Repository
import SignFeature
import User
import UserInterface

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  let localStorage = LocalStorage()
  private var appCoordinator: AppCoordinator?
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    Fonts.registerFont()
    registerDependency(localStorage: localStorage)

    let navigationController = UINavigationController()
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = navigationController
    
    self.appCoordinator = AppCoordinator(
      navigationController: navigationController
    )
    appCoordinator?.start(animated: false)
    
    self.scene(scene, openURLContexts: connectionOptions.urlContexts)
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }

    if url.absoluteString.contains("widget://") {
      DeepLinkManager.setDestination(url.absoluteString, agencyID: localStorage.selectedAgency)
    } else {
      KakaoAuthManager.shared.openURL(url)
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
  func registerDependency(localStorage: LocalStorage) {
    let networkManager = NetworkManager()
    let ledgerService = LedgerService()
    let contentFormatter = ContentFormatter()
    
    networkManager.tokenIntercepter = TokenRequestIntercepter(
      localStorage: localStorage,
      tokenRepository: TokenRepository(
        networkManager: networkManager,
        localStorage: localStorage
      )
    )
    
    let widgetRefreshController = WidgetRefreshController()
    
    // MARK: - User UseCase Dependency
    DIContainer.shared.register(type: GetMyInfoUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return GetMyInfoUseCase(userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: SearchUniversitiesUseCaseInterface.self) {
      let universityRepo = UniversityRepository(networkManager: networkManager)
      return SearchUniversitiesUseCase(universityRepo: universityRepo)
    }
    
    DIContainer.shared.register(type: GetSelectedAgencyUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return GetSelectedAgencyUseCase(userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: UpdateSelectedAgencyUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return UpdateSelectedAgencyUseCase(userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: GetUserIDUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return GetUserIDUseCase(userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: RegisterUniversitiesUseCaseInterface.self) {
      let universityRepo = UniversityRepository(networkManager: networkManager)
      return RegisterUniversitiesUseCase(universityRepo: universityRepo)
    }
    
    // MARK: - Auth UseCase Dependency
    DIContainer.shared.register(type: AutoSignUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      let versionRepo = VersionRepository(networkManager: networkManager)
      return AutoSignUseCase(userRepo: userRepo, versionRepo: versionRepo)
    }
    
    DIContainer.shared.register(type: DeleteUserUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return DeleteUserUseCase(userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: LogoutUseCaseInterface.self) {
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return LogoutUseCase(userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: SignUpUseCaseInterface.self) {
      let signRepo = SignRepository(networkManager: networkManager, localStorage: localStorage)
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return SignUpUseCase(signRepo: signRepo, userRepo: userRepo)
    }
    
    DIContainer.shared.register(type: GetRecentLoginInfoUseCaseInterface.self) {
      let signRepo = SignRepository(networkManager: networkManager, localStorage: localStorage)
      return GetRecentLoginInfoUseCase(signRepo: signRepo)
    }
    
    // MARK: - Agency UseCase Dependency
    DIContainer.shared.register(type: ChangeMemberRoleUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return ChangeMemberRoleUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: ConfirmCertificateCodeUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return ConfirmCertificateCodeUseCase(agencyRepo: agencyRepo, userRepo: userRepo)
    }

    DIContainer.shared.register(type: CreateAgencyUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return CreateAgencyUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: DeleteAgencyUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      let userRepo = UserRepository(networkManager: networkManager, localStorage: localStorage, memoryCache: MemoryCache.shared)
      return DeleteAgencyUseCase(agencyRepo: agencyRepo, userRepo: userRepo, widgetRefreshController: widgetRefreshController)
    }

    DIContainer.shared.register(type: GetAgencyListUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return GetAgencyListUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: GetInvitationCodeUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return GetInvitationCodeUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: GetMemberListUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return GetMemberListUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: GetMyAgencyUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return GetMyAgencyUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: KickoutMemberUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return KickoutMemberUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: ReissueCodeUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return ReissueCodeUseCase(repo: agencyRepo)
    }

    DIContainer.shared.register(type: SearchAgencyUseCaseInterface.self) {
      let agencyRepo = AgencyRepository(networkManager: networkManager, localStorage: localStorage)
      return SearchAgencyUseCase(repo: agencyRepo)
    }
    
    // MARK: - Ledger UseCase Dependency
    DIContainer.shared.register(type: CreateLedgerUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return CreateLedgerUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: DeleteDocumentUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return DeleteDocumentUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: DeleteImageUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return DeleteImageUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: DeleteLedgerUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return DeleteLedgerUseCase(ledgerRepo: ledgerRepo)
    }

//    DIContainer.shared.register(type: DeleteReceiptUseCaseInterface.self) {
//      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
//      return DeleteReceiptUseCase(ledgerRepo: ledgerRepo)
//    }

    DIContainer.shared.register(type: GetLedgerDateRangeUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return GetLedgerDateRangeUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: GetLedgerDetailUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return GetLedgerDetailUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: GetLedgerListUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return GetLedgerListUseCase(ledgerRepo: ledgerRepo, widgetRefreshController: widgetRefreshController)
    }

    DIContainer.shared.register(type: SaveLedgerDateRangeUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return SaveLedgerDateRangeUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: UpdateLedgerUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return UpdateLedgerUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: UploadDocumentUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return UploadDocumentUseCase(ledgerRepo: ledgerRepo)
    }

    DIContainer.shared.register(type: UploadImageUseCaseInterface.self) {
      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
      return UploadImageUseCase(ledgerRepo: ledgerRepo)
    }

//    DIContainer.shared.register(type: UploadReceiptUseCaseInterface.self) {
//      let ledgerRepo = LedgerRepository(networkManager: networkManager, localStorage: localStorage)
//      return UploadReceiptUseCase(ledgerRepo: ledgerRepo)
//    }
    
    // MARK: - Coordinator Dependency
    DIContainer.shared.register(type: MyPageCoordinatorInterface.self) {
      return MyPageCoordinator()
    }
    
    DIContainer.shared.register(type: AgencyCoordinatorInterface.self) {
      return AgencyCoordinator()
    }
    
    DIContainer.shared.register(type: CreateAgencyCoordinatorInterface.self) {
      return CreateAgencyCoordinator()
    }
    
    DIContainer.shared.register(type: LedgerCoordinatorInterface.self) {
      return LedgerCoordinator(ledgerService: ledgerService, contentFormatter: contentFormatter)
    }
    
    DIContainer.shared.register(type: CreateManualLedgerCoordinatorInterface.self) {
      return CreateManualLedgerCoordinator(ledgerService: ledgerService, contentFormatter: contentFormatter)
    }
  }
}
