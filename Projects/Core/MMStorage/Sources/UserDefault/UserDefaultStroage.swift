import Foundation

public final class UserDefaultStroage: UserDefaultStorageInterface {
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
