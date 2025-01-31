
public protocol ReusableView: AnyObject {
  static var reuseIdentifier: String { get }
}

extension ReusableView {
  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}
