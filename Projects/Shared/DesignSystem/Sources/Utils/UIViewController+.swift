import UIKit

// 나중에 BaseVC로 옮길예정
public extension UIViewController {
  enum BarItem {
    case back
    case closeBlack
    case closeWhite
    case trash
    case 수정완료
    
    var button: UIBarButtonItem {
      let button = UIBarButtonItem()
      
      switch self {
      case .back:
        button.image = Images.chevronLeft?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.Gray._7
      case .closeBlack:
        button.image = Images.close?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.Gray._7
      case .closeWhite:
        button.image = Images.close?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.White._1
      case .trash:
        button.image = Images.trash?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.Gray._7
      case .수정완료:
        button.title = "수정완료"
        button.setTitleTextAttributes([.font: Fonts.body._3], for: .normal)
        button.tintColor = Colors.Blue._4
      }
      
      return button
    }
  }
  
  func setTitle(_ title: String, color: UIColor = Colors.Gray._10, font: UIFont = Fonts.heading._1) {
    let label = UILabel()
    label.text = title
    label.textColor = color
    label.font = font
    
    navigationItem.titleView = label
  }
  
  func setTitle(_ titleView: UIView) {
    navigationItem.titleView = titleView
  }
  
  func setLeftItem(_ item: BarItem) {
    navigationItem.leftBarButtonItem = item.button
  }
  
  func setRightItem(_ item: BarItem) {
    navigationItem.rightBarButtonItem = item.button
  }
  
  func searchTopViewController() -> UIViewController {
    if let presentedViewController = self.presentedViewController {
      return presentedViewController.searchTopViewController()
    }
    if let navigationViewController = self as? UINavigationController,
       let topViewController = navigationViewController.topViewController {
      return topViewController.searchTopViewController()
    }
    if let tabBarController = self as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController {
      return selectedViewController.searchTopViewController()
    }
    return self
  }
}
