import Foundation

public final class DIContainer {
  
  public static let shared: DIContainer = .init()
  
  private init() {}
  
  public var storage: [String : () -> Any] = [:]
  
  public func register<T>(type: T.Type, value: @escaping () -> T) {
    storage[String(describing: type)] = value
  }
  
  public func resolve<T>(type: T.Type) -> T {
    guard let object = storage[String(describing: type)]?() as? T else {
      fatalError("Could not resolve \(type)")
    }
    return object
  }
}
