import Foundation
import Security

public final class KeychainHelper {
  public static let shared = KeychainHelper()

  private init() { }

  @discardableResult
  public func create<T: Codable>(to key: KeychainServiceKey, value: T) -> Bool {
    let addQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
    ]

    let result: Bool = {
      let status = SecItemAdd(addQuery as CFDictionary, nil)
      if status == errSecSuccess {
        return true
      } else if status == errSecDuplicateItem {
        return update(key: key, value: value)
      }

      debugPrint("addItem Error : \(key))")
      return false
    }()

    return result
  }

  @discardableResult
  public func read<T: Codable>(key: KeychainServiceKey, type: T.Type) -> T? {
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
         let data = existingItem[kSecValueData as String] as? Data {
        do {
          let decodedValue = try JSONDecoder().decode(type, from: data)
          return decodedValue
        } catch {
          debugPrint("Decoding Error: \(error)")
        }
      }
    }
    debugPrint("getItem Error: \(key)")
    return nil
  }

  @discardableResult
  public func update<T: Codable>(key: KeychainServiceKey, value: T) -> Bool {
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

      debugPrint("updateItem Error : \(key.rawValue)")
      return false
    }()

    return result
  }

  @discardableResult
  public func delete(key: KeychainServiceKey) -> Bool {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    let status = SecItemDelete(query as CFDictionary)
    if status == errSecSuccess { return true }

    debugPrint("delete Error : \(key.rawValue)")
    return false
  }
}
