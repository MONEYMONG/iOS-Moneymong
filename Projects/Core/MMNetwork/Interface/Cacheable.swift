import Foundation

public protocol Cacheable {
  func save(data: Data, key: String)
  func delete(key: String)
  func read(key: String) -> Data?
  func deleteAll()
}
