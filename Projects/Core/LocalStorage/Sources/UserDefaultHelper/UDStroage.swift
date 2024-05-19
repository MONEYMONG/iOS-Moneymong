import Foundation

@propertyWrapper
public struct UD<T: Codable> {
  private let key: LocalStorageKey.UD
  private let storage: UDStorageInterface
  
  public init(key: LocalStorageKey.UD, storage: UDStorageInterface = UDStorage()) {
    self.key = key
    self.storage = storage
  }
  
  public var wrappedValue: T? {
    get { storage.get(forKey: key) }
    set { storage.set(newValue, forKey: key) }
  }
}

public protocol UDStorageInterface {
  func get<T: Codable>(forKey key: LocalStorageKey.UD) -> T?
  func set<T: Codable>(_ newValue: T, forKey key: LocalStorageKey.UD)
}

public final class UDStorage: UDStorageInterface {
  private let storage: UserDefaults
  
  public init(storage: UserDefaults = UserDefaults.standard) {
    self.storage = storage
  }
  
  public func get<T: Codable>(forKey key: LocalStorageKey.UD) -> T? {
    guard let data = storage.value(forKey: key.rawValue) as? Data else {
      debugPrint("\(key) 조회 실패")
      return nil
    }

    guard let value = try? JSONDecoder().decode(T.self, from: data) else {
      debugPrint("\(key) 조회 실패")
      return nil
    }
    
    return value
  }
  
  public func set<T: Codable>(_ newValue: T, forKey key: LocalStorageKey.UD) {
    if let data = try? JSONEncoder().encode(newValue) {
      debugPrint("\(key) 저장 성공")
      storage.setValue(data, forKey: key.rawValue)
    } else {
      debugPrint("\(key) 저장 실패")
    }
  }
}
