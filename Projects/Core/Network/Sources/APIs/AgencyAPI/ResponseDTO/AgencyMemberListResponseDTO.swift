import Foundation

/// 소속 멤버리스트 조회
struct AgencyMemberListResponseDTO: Responsable {
  let count: Int
  let agencyUsers: [User]
  
  struct User: Decodable {
    let id: Int
    let userId: Int
    let nickname: String
    let agencyUserRole: String
  }
  
  var toEntity: [Member] {
    self.agencyUsers.map {
      .init(
        agencyID: $0.id,
        userID: $0.userId,
        nickname: $0.nickname,
        role: .init(rawValue: $0.agencyUserRole) ?? .member
      )
    }
  }
}
