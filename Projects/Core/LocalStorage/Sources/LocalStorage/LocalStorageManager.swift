import Foundation

public protocol LocalStorageInterface: AnyObject {
  @discardableResult
  func create(to key: LocalStorageKey, value: String) -> Bool

  func read(to key: LocalStorageKey) -> String?

  @discardableResult 
  func delete(to key: LocalStorageKey) -> Bool
}

public final class LocalStorageManager: LocalStorageInterface {
  private let keychainHelper: KeychainHelper
  private let userDefaults: UserDefaults

  public init(keychainHelper: KeychainHelper = KeychainHelper()) {
    self.keychainHelper = keychainHelper
    self.userDefaults = UserDefaults.standard
  }

  @discardableResult
  public func create(to key: LocalStorageKey, value: String) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.create(to: .accessToken, value: value)
    case .refreshToken:
      return keychainHelper.create(to: .refreshToken, value: value)
    case .selectedAgency:
      userDefaults.setValue(value, forKey: key.rawValue)
      return true
    }
  }

  public func read(to key: LocalStorageKey) -> String? {
    switch key {
    case .accessToken:
      keychainHelper.read(to: .accessToken)
    case .refreshToken:
      keychainHelper.read(to: .refreshToken)
    case .selectedAgency:
      userDefaults.value(forKey: key.rawValue) as? String
    }
  }

  @discardableResult
  public func delete(to key: LocalStorageKey) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.delete(to: .accessToken)
    case .refreshToken:
      return keychainHelper.delete(to: .refreshToken)
    case .selectedAgency:
      userDefaults.removeObject(forKey: key.rawValue)
      return true
    }
  }
}
