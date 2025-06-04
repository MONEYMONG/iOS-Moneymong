import Foundation

/// 소속
public struct Agency: Equatable {
  public let id: Int
  public let name: String
  public let count: Int
  
  public init(
    id: Int,
    name: String,
    count: Int
  ) {
    self.id = id
    self.name = name
    self.count = count
  }
}
