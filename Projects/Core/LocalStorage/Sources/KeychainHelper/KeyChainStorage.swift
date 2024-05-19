import Foundation
import Security

@propertyWrapper
public struct Keychain {
  private let key: LocalStorageKey.Keychain
  private let storage: KeychainStorageInterface
  
  public init(key: LocalStorageKey.Keychain, storage: KeychainStorageInterface = KeychainStorage()) {
    self.key = key
    self.storage = storage
  }
  
  public var wrappedValue: String? {
    get {
      storage.get(forKey: key)
    }
    
    set {
      if let newValue {
        storage.set(newValue, forKey: key)
      } else {
        storage.delete(forKey: key)
      }
    }
  }
}

public protocol KeychainStorageInterface {
  func get(forKey key: LocalStorageKey.Keychain) -> String?
  func set(_ newValue: String, forKey key: LocalStorageKey.Keychain)
  func delete(forKey key: LocalStorageKey.Keychain)
}

public final class KeychainStorage: KeychainStorageInterface {
  
  public init() { }
  
  public func get(forKey key: LocalStorageKey.Keychain) -> String? {
    let getQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecReturnAttributes: true,
      kSecReturnData: true
    ]
    
    var item: CFTypeRef?
    let result = SecItemCopyMatching(getQuery as CFDictionary, &item)

    guard result == errSecSuccess else {
      debugPrint("keychain 조회 실패")
      return nil
    }
    
    guard let existingItem = item as? [String: Any],
          let data = existingItem[kSecValueData as String] as? Data,
          let password = String(data: data, encoding: .utf8)
    else {
      debugPrint("\(key) 조회 실패")
      return nil
    }
    
    debugPrint("\(key) 조회 성공")
    return password
  }
  
  public func set(_ newValue: String, forKey key: LocalStorageKey.Keychain) {
    let addQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecValueData: (newValue as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
    ]
    
    let result = SecItemAdd(addQuery as CFDictionary, nil)
    switch result {
    case errSecSuccess:
      debugPrint("\(key) 저장 성공")
    case errSecDuplicateItem:
      debugPrint("\(key) 저장 중복")
      update(newValue, forKey: key)
    default:
      debugPrint("\(key) 저장 실패")
    }
  }
  
  public func delete(forKey key: LocalStorageKey.Keychain) {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    if status == errSecSuccess {
      debugPrint("\(key) 삭제 성공")
    } else {
      debugPrint("\(key) 삭제 실패")
    }
  }
  
  private func update(_ newValue: String, forKey key: LocalStorageKey.Keychain) {
    let prevQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    
    let updateQuery: [CFString: Any] = [
      kSecValueData: (newValue as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
    ]
    
    let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
    
    if status == errSecSuccess {
      debugPrint("\(key) 업데이트 성공")
    } else {
      debugPrint("\(key) 업데이트 실패")
    }
  }
}
