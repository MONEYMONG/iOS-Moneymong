import Foundation

/// 맴버
public struct Member {
  public let agencyID: Int
  public let userID: Int
  public let nickname: String
  let role: Role
  
  public enum Role: String {
    case staff = "STAFF"
    case normal = "NORMAL"
  }
  
  public init(agencyID: Int, userID: Int, nickname: String, role: Role) {
    self.agencyID = agencyID
    self.userID = userID
    self.nickname = nickname
    self.role = role
  }
}
