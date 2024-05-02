import Foundation

public final class UserDefaultsHelper {
  private let userDefaults = UserDefaults.standard

  public init() {}

  public func retrieveArrayData<T: Codable>(forKey: UserDefaultsKey, type: T.Type) -> T? {
    return userDefaults.array(forKey: forKey.rawValue) as? T
  }

  public func saveArrayData<T: Codable>(newValue: T, forKey: UserDefaultsKey) {
    userDefaults.set(newValue, forKey: forKey.rawValue)
  }

  public func retrieveData<T: Codable>(forKey: UserDefaultsKey, type: T.Type) -> T? {
    if let retrievedData = userDefaults.object(forKey: forKey.rawValue) as? Data {
      let decoder = JSONDecoder()
      if let data = try? decoder.decode(type, from: retrievedData) {
        return data
      }
    }
    return nil
  }

  @discardableResult
  public func saveData<T: Codable>(newValue: T, forKey: UserDefaultsKey) -> Bool {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(newValue) {
      userDefaults.setValue(encoded, forKey: forKey.rawValue)
      userDefaults.synchronize()
      return true
    }
    return false
  }

  public func delete<T: Codable>(forKey: UserDefaultsKey, type: T.Type) -> Bool {
    userDefaults.removeObject(forKey: forKey.rawValue)
    userDefaults.synchronize()

    let value = retrieveData(forKey: forKey, type: type)
    return value == nil
  }
}
