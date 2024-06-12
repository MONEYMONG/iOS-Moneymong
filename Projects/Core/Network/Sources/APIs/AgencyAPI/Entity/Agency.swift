import Foundation

/// 소속
public struct Agency: Equatable {
  public let id: Int
  public let name: String
  public let count: Int
  public let type: `Type`
  
  public enum `Type`: String {
    case council = "STUDENT_COUNCIL"
    case club = "IN_SCHOOL_CLUB"
    
    public var name: String {
      switch self {
      case .council: "학생회"
      case .club: "동아리"
      }
    }
  }
  
  public init(id: Int, name: String, count: Int, type: Type) {
    self.id = id
    self.name = name
    self.count = count
    self.type = type
  }
}
