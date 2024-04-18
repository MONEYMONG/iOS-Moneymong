import UIKit

public extension UITableView {
  func register<T: UITableViewCell>(_ : T.Type) where T: ResuableView {
    self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ : T.Type) where T: ResuableView {
    self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueCell<T: UITableViewCell>(_ : T.Type, for indexPath: IndexPath) -> T where T: ResuableView {
    self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(_ : T.Type, for indexPath: IndexPath) -> T where T: ResuableView {
    self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
  }
}
