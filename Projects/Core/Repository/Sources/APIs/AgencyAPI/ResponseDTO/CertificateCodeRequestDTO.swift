import Foundation

import BaseDomain
import MMNetworkInterface

/// 초대코드 인증 Response
struct CertificateCodeRequestDTO: Responsable {
  let certified: Bool
  let agencyId: Int
  
  var toEntity: CertificationResult { CertificationResult(certified: certified, agencyId: agencyId) }
}
