import UIKit

import DesignSystem

public final class MainTapViewController: UITabBarController {
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupTabBar()
  }

  private func setupTabBar() {
    let titles = ["소속, 장부, 마이페이지"]
    let images: [UIImage?] = [Images.party, Images.record, Images.mongGray]
    
    tabBar.items?.enumerated().forEach { (index, item) in
      item.title = titles[index]
      item.image = images[index]
      item.selectedImage = images[index]?.withRenderingMode(.alwaysTemplate).withTintColor(Colors.Blue._4)
    }
    
    tabBar.tintColor = Colors.Blue._4
  }
}
