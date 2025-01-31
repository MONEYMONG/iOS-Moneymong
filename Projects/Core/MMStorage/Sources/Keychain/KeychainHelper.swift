@propertyWrapper
public struct Keychain {
  private let key: LocalStorageKey.Keychain
  private let storage: KeychainStorageInterface
  
  public init(key: LocalStorageKey.Keychain, storage: KeychainStorageInterface = KeychainStorage()) {
    self.key = key
    self.storage = storage
  }
  
  public var wrappedValue: String? {
    get {
      storage.get(forKey: key)
    }
    
    set {
      if let newValue {
        storage.set(newValue, forKey: key)
      } else {
        storage.delete(forKey: key)
      }
    }
  }
}
