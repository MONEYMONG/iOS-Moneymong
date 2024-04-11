import UIKit

public final class MainTapViewController: UITabBarController {
  public init() {
    super.init(nibName: nil, bundle: nil)
    setupTabBar()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
  }
  
  private func setupTabBar() {
    let v1 = UIViewController()
    v1.view.backgroundColor = .red
    let vc1 = UINavigationController(rootViewController: v1)
    let vc2 = UINavigationController(rootViewController: .init())
    let vc3 = UINavigationController(rootViewController: .init())
    setViewControllers([vc1, vc2, vc3], animated: true)
    
    if let items = tabBar.items {
      items[0].title = "소속"
      items[1].title = "장부"
      items[2].title = "마이페이지"
    }
  }
}
