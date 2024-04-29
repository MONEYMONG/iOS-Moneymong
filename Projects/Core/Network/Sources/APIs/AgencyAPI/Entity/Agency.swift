import Foundation

/// 소속
public struct Agency {
  public let id: Int
  public let name: String
  public let type: `Type`
  
  public enum `Type`: String {
    case student = "STUDENT_COUNCIL"
  }
  
  public init(id: Int, name: String, type: Type) {
    self.id = id
    self.name = name
    self.type = type
  }
}
