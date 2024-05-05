import Foundation

public struct ImageURL {
  public let key: String
  public let url: String
  public var id: UUID?
  
  public init(key: String, url: String) {
    self.key = key
    self.url = url
  }
}
