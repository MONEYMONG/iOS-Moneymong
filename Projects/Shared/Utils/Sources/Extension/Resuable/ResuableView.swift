public protocol ResuableView: AnyObject {
  static var reuseIdentifier: String { get }
}

public extension ResuableView {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
