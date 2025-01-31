@propertyWrapper
public struct UD<T: Codable> {
  private let key: LocalStorageKey.UD
  private let storage: UserDefaultStorageInterface
  
  public init(key: LocalStorageKey.UD, storage: UserDefaultStorageInterface = UserDefaultStroage()) {
    self.key = key
    self.storage = storage
  }
  
  public var wrappedValue: T? {
    get { storage.get(forKey: key) }
    set { storage.set(newValue, forKey: key) }
  }
}
