public protocol UserDefaultStorageInterface {
  func get<T: Codable>(forKey key: LocalStorageKey.UD) -> T?
  func set<T: Codable>(_ newValue: T, forKey key: LocalStorageKey.UD)
}

