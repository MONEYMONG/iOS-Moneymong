import Foundation

/// 초대코드 인증 요청에 사용
struct InvitationCodeCertificationRequestDTO: Encodable {
  let invitationCode: String
}
