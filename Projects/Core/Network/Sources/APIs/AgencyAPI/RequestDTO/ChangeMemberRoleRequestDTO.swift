import Foundation

/// 맴버 역할 변경 요청
struct ChangeMemberRoleRequestDTO: Encodable {
  let userId: Int
  let role: String
}
