public protocol LocalStorageInterface: AnyObject {
  func create(to key: LocalStorageKey, value: String)
  func read(to key: LocalStorageKey) -> String?
}
public final class LocalStorageManager: LocalStorageInterface {
  private let keychainHelper: KeychainHelper

  public init(keychainHelper: KeychainHelper = .shared) {
    self.keychainHelper = keychainHelper
  }

  public func create(to key: LocalStorageKey, value: String) {
    switch key {
    case .accessToken:
      keychainHelper.create(to: .accessToken, value: value)
    case .refreshToken:
      keychainHelper.create(to: .refreshToken, value: value)
    }
  }

  public func read(to key: LocalStorageKey) -> String? {
    switch key {
    case .accessToken:
      keychainHelper.read(to: .accessToken)
    case .refreshToken:
      keychainHelper.read(to: .refreshToken)
    }
  }
}
