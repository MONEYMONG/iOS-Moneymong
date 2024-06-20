import UIKit

import BaseFeature
import DesignSystem

import RxSwift

public final class MainTapViewController: UITabBarController {
  private let disposeBag = DisposeBag()

  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    print(#function)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupTabBar()
    bind()
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
  }
}
