
public protocol KeychainStorageInterface {
  func get(forKey key: LocalStorageKey.Keychain) -> String?
  func set(_ newValue: String, forKey key: LocalStorageKey.Keychain)
  func delete(forKey key: LocalStorageKey.Keychain)
}
