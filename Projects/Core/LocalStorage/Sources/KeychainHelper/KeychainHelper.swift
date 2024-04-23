import Foundation
import Security

public final class KeychainHelper {
  public static let shared = KeychainHelper()

  private init() { }

  // Create
  public func create(key: KeychainServiceKey, value: String) {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: value.data(using: .utf8, allowLossyConversion: false) as Any
    ]
    SecItemDelete(query)

    let status = SecItemAdd(query, nil)
    assert(status == noErr, "failed to save Value")
  }

  // Read
  public func read(key: KeychainServiceKey) -> String? {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: kCFBooleanTrue as Any,
      kSecMatchLimit: kSecMatchLimitOne
    ]

    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query, &dataTypeRef)

    if status == errSecSuccess {
      if let retrievedData: Data = dataTypeRef as? Data {
        let value = String(data: retrievedData, encoding: String.Encoding.utf8)
        return value
      } else { return nil }
    } else {
      print("failed to loading, status code = \(status)")
      return nil
    }
  }

  // Delete
  public func delete(key: KeychainServiceKey) {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key
    ]
    let status = SecItemDelete(query)
    assert(status == noErr, "failed to delete the value, status code = \(status)")
  }
}
