import Foundation

/// 소속
public struct Agency: Equatable {
  public let id: Int
  public let name: String
  public let count: Int
  public let type: `Type`
  
  public enum `Type`: String {
    case student = "STUDENT_COUNCIL"
  }
  
  public init(id: Int, name: String, count: Int, type: Type) {
    self.id = id
    self.name = name
    self.count = count
    self.type = type
  }
}
