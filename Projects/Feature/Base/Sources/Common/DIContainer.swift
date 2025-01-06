import Foundation

public final class DIContainer {
  
  public static let shared: DIContainer = .init()
  
  private init() {}
  
  private var storage: [String : () -> Any] = [:]
  
  public func register<T>(type: T.Type, value: @escaping () -> T) {
    storage[String(describing: type)] = value
  }
  
  public func resolve<T>(type: T.Type) -> T {
    return storage[String(describing: type)]!() as! T
  }
}
