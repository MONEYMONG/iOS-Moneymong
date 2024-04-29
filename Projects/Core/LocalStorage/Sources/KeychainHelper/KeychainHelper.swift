import Foundation
import Security

public final class KeychainHelper {

  public init() { }

  @discardableResult
  public func create(to key: KeychainServiceKey, value: String) -> Bool {
    let addQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
    ]

    let result: Bool = {
      let status = SecItemAdd(addQuery as CFDictionary, nil)
      if status == errSecSuccess {
        return true
      } else if status == errSecDuplicateItem {
        return update(to: key, value: value)
      }

      debugPrint("addItem Error : \(key))")
      return false
    }()

    return result
  }

  @discardableResult
  public func read(to key: KeychainServiceKey) -> String? {
    let getQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecReturnAttributes: true,
      kSecReturnData: true
    ]
    var item: CFTypeRef?
    let result = SecItemCopyMatching(getQuery as CFDictionary, &item)

    if result == errSecSuccess {
      if let existingItem = item as? [String: Any],
         let data = existingItem[kSecValueData as String] as? Data,
         let password = String(data: data, encoding: .utf8) {
        return password
      }
    }

    debugPrint("getItem Error : \(key)")
    return nil
  }

  @discardableResult
  public func update(to key: KeychainServiceKey, value: String) -> Bool {
    let prevQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    let updateQuery: [CFString: Any] = [
      kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
    ]

    let result: Bool = {
      let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
      if status == errSecSuccess { return true }

      debugPrint("updateItem Error : \(key)")
      return false
    }()

    return result
  }

  @discardableResult
  public func delete(to key: KeychainServiceKey) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    let status = SecItemDelete(query as CFDictionary)
    if status == errSecSuccess { return true }

    debugPrint("delete Error : \(key)")
    return false
  }
}