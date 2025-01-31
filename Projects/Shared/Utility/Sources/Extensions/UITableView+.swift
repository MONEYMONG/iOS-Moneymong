import UIKit

public extension UITableView {
  func register<T: UITableViewCell>(_ type: T.Type) where T: ReusableView {
    self.register(type, forCellReuseIdentifier: type.reuseIdentifier)
  }
  
  func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) where T: ReusableView {
    self.register(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
  }
  
  func dequeue<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T where T: ReusableView {
    return self.dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
  }
  
  func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T where T: ReusableView {
    return self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseIdentifier) as! T
  }
}
