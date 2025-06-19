import UIKit
import SafariServices

public enum Scene {
  case main // 메인화면
  case login // 로그인화면
  case ledger // 장부화면
  case createManualLedger(Int) // 운영비 등록화면
  case createAgency // 소속 생성
}

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController? { get set }
  var parentCoordinator: Coordinator? { get set }

  func move(to scene: Scene) // 특정 화면으로 이동 (부모에게 요청)
}

public extension Coordinator {
  func move(to scene: Scene) {
    switch scene {
    case .main:
      parentCoordinator?.move(to: .main)
    case .login:
      parentCoordinator?.move(to: .login)
    case .ledger:
      parentCoordinator?.move(to: .ledger)
    case let .createManualLedger(id):
      parentCoordinator?.move(to: .createManualLedger(id))
    case .createAgency:
      parentCoordinator?.move(to: .createAgency)
    }
  }
  
  func web(urlString: String, animated: Bool = true) {
    guard let url = URL(string: urlString) else {
      return debugPrint("Invalid URL", #function)
    }
    
    let vc = SFSafariViewController(url: url)
    navigationController?.topViewController?.present(vc, animated: animated)
  }
}
