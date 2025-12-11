import Foundation

public final class DIContainer {
  private struct WeakElement {
    weak var element: AnyObject?
    
    init(element: AnyObject? = nil) {
      self.element = element
    }
  }
  
  public static let shared: DIContainer = .init()
  
  private init() {}
  
  private var storage: [String : () -> Any] = [:]
  private var weakTable: [String : WeakElement] = [:]
  
  public func register<T>(type: T.Type, value: @escaping () -> T) {
    storage[String(describing: type)] = value
  }
  
  public func resolve<T>(type: T.Type) -> T {
    let key = String(describing: type)
    
    if let element = weakTable[key]?.element as? T {
        return element
    }
    
    guard let object = storage[key]?() as? T else {
      fatalError("Could not resolve \(type)")
    }
    
    if Mirror(reflecting: object).displayStyle == .class {
      weakTable[key] = WeakElement(element: object as AnyObject)
    }
    
    return object
  }
}
