import Foundation

/// 초대코드 발급 / 재발급에 사용
public struct InvitationCodeResponseDTO: Responsable {
  let code: String
  
  public var toEntity: String { return self.code }
}
