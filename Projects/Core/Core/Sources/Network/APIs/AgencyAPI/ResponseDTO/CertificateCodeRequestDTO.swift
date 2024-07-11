import Foundation

/// 초대코드 인증 Response
struct CertificateCodeRequestDTO: Responsable {
  let certified: Bool
  
  var toEntity: Bool { return certified }
}
