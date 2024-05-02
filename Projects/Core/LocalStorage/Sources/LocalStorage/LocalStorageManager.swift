public protocol LocalStorageInterface: AnyObject {
  @discardableResult 
  func create(to key: LocalStorageKey, value: String) -> Bool

  func read(to key: LocalStorageKey) -> String?

  @discardableResult 
  func delete(to key: LocalStorageKey) -> Bool
}

public final class LocalStorageManager: LocalStorageInterface {
  private let keychainHelper: KeychainHelper
  private let userDefaultHelper: UserDefaultsHelper

  public init(
    keychainHelper: KeychainHelper = KeychainHelper(),
    userDefaultHelper: UserDefaultsHelper = UserDefaultsHelper()
  ) {
    self.keychainHelper = keychainHelper
    self.userDefaultHelper = userDefaultHelper
  }

  @discardableResult
  public func create(to key: LocalStorageKey, value: String) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.create(to: .accessToken, value: value)
    case .refreshToken:
      return keychainHelper.create(to: .refreshToken, value: value)
    case .recentLoginType:
      return userDefaultHelper.saveData(newValue: value, forKey: .recentLoginType)
    }
  }

  public func read(to key: LocalStorageKey) -> String? {
    switch key {
    case .accessToken:
      return keychainHelper.read(to: .accessToken)
    case .refreshToken:
      return keychainHelper.read(to: .refreshToken)
    case .recentLoginType:
      return userDefaultHelper.retrieveData(forKey: .recentLoginType, type: String.self)
    }
  }

  @discardableResult
  public func delete(to key: LocalStorageKey) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.delete(to: .accessToken)
    case .refreshToken:
      return keychainHelper.delete(to: .refreshToken)
    case .recentLoginType:
      return userDefaultHelper.delete(forKey: .recentLoginType, type: String.self)
    }
  }
}
