import UIKit

import BaseFeature
import Core
import DesignSystem

import RxSwift

public final class MainTapViewController: UITabBarController {
  private let disposeBag = DisposeBag()
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    debugPrint(#function)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupTabBar()
    
    observeNotification()
  }
  
  private func setupTabBar() {
    tabBar.layer.borderWidth = 1
    tabBar.layer.borderColor = Colors.Gray._2.cgColor
    tabBar.backgroundColor = .white
    tabBar.setShadow(location: .center, opacity: 0.15, radius: 6.0)
    let appearance = UITabBarItem.appearance()
    let attributes = [NSAttributedString.Key.font: Fonts.body._2]
    appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    
    let titles = ["소속", "장부", "마이몽"]
    let images: [UIImage?] = [Images.mongParty, Images.record, Images.mongGray]
    
    tabBar.items?.enumerated().forEach { (index, item) in
      item.title = titles[index]
      item.image = images[index]?.withRenderingMode(.alwaysTemplate)
      item.selectedImage = images[index]?.withRenderingMode(.alwaysTemplate)
    }
    
    tabBar.tintColor = Colors.Blue._4
    tabBar.unselectedItemTintColor = Colors.Gray._4
  }
  
  private func bind() {
    NotificationCenter.default.rx.notification(.tabBarHidden)
      .compactMap { $0.object as? Bool }
      .bind(with: self, onNext: { owner, value in
        owner.tabBar.isHidden = value
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(.moveLedger)
      .bind(with: self) { owner, noti in
        owner.selectedIndex = 1
        if let id = noti.userInfo?["id"] as? Int {
          NotificationCenter.default.post(name: .presentManualCreater, object: nil, userInfo: ["id" : id])
        }
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(.moveAgency)
      .bind(with: self) { owner, _ in
        owner.selectedIndex = 0
      }
      .disposed(by: disposeBag)
  }
  
  private func observeNotification() {
    NotificationCenter.default.rx
      .notification(.init("deeplink"))
      .compactMap { noti -> (query: String, agencyID: Int)? in
        guard let query = noti.userInfo?["query"] as? String,
              let agencyID = noti.userInfo?["agencyID"] as? Int else { return nil }
        return (query, agencyID)
      }
      .bind(with: self) { owner, userInfo in
        switch userInfo.query {
        case "OCR":
          owner.selectedIndex = 1
          NotificationCenter.default.post(name: .presentOCRCreater, object: nil, userInfo: ["id" : userInfo.agencyID])
        case "CreateLedger":
          owner.selectedIndex = 1
          NotificationCenter.default.post(name: .presentManualCreater, object: nil, userInfo: ["id" : userInfo.agencyID])
        case "LedgerDetail":
          owner.selectedIndex = 1
        default: break
        }
        
        DeepLinkManager.clear();
      }
      .disposed(by: disposeBag)
    
    if let destination = DeepLinkManager.destination {
      NotificationCenter.default.post(
        name: .init("deeplink"),
        object: nil,
        userInfo: [
          "query": destination.query,
          "agencyID": destination.agencyID
        ]
      )
    }
  }
}
