import Foundation

/// 맴버
public struct Member {
  public let agencyID: Int
  public let userID: Int
  public let nickname: String
  public let role: Role
  
  public enum Role: String {
    case staff = "STAFF"
    case member = "MEMBER"
  }
  
  public init(agencyID: Int, userID: Int, nickname: String, role: Role) {
    self.agencyID = agencyID
    self.userID = userID
    self.nickname = nickname
    self.role = role
  }
}
