public protocol LocalStorageInterface: AnyObject {
  @discardableResult 
  func create(to key: LocalStorageKey, value: String) -> Bool

  func read(to key: LocalStorageKey) -> String?

  @discardableResult 
  func delete(to key: LocalStorageKey) -> Bool
}

public final class LocalStorageManager: LocalStorageInterface {
  private let keychainHelper: KeychainHelper

  public init(keychainHelper: KeychainHelper = KeychainHelper()) {
    self.keychainHelper = keychainHelper
  }

  @discardableResult
  public func create(to key: LocalStorageKey, value: String) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.create(to: .accessToken, value: value)
    case .refreshToken:
      return keychainHelper.create(to: .refreshToken, value: value)
    }
  }

  public func read(to key: LocalStorageKey) -> String? {
    switch key {
    case .accessToken:
      return keychainHelper.read(to: .accessToken)
    case .refreshToken:
      return keychainHelper.read(to: .refreshToken)
    }
  }

  @discardableResult
  public func delete(to key: LocalStorageKey) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.delete(to: .accessToken)
    case .refreshToken:
      return keychainHelper.delete(to: .refreshToken)
    }
  }
}
