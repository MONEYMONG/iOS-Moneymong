public protocol LocalStorageInterface: AnyObject {
  func create<T: Codable>(to key: LocalStorageKey, value: T)
  func read<T: Codable>(to key: LocalStorageKey, type: T.Type) -> T?
}

public enum LocalStorageKey: String {
  case accessToken
  case refreshToken
}

public final class LocalStorageManager: LocalStorageInterface {
  private let keychainHelper: KeychainHelper

  public init(keychainHelper: KeychainHelper = .shared) {
    self.keychainHelper = keychainHelper
  }

  public func create<T: Codable>(to key: LocalStorageKey, value: T) {
    switch key {
    case .accessToken:
      keychainHelper.create(to: .accessToken, value: value)
    case .refreshToken:
      keychainHelper.create(to: .refreshToken, value: value)
    }
  }

  public func read<T: Codable>(to key: LocalStorageKey, type: T.Type) -> T? {
    switch key {
    case .accessToken:
      keychainHelper.read(key: .accessToken, type: type)
    case .refreshToken:
      keychainHelper.read(key: .refreshToken, type: type)
    }
  }
}
