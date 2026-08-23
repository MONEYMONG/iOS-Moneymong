import Foundation

import BaseDomain

// 소속가입시, 초대코드가 맞는지 확인한다
public protocol ConfirmCertificateCodeUseCaseInterface {
  func execute(code: [String]) async throws -> Agency?
  func execute(code: String, agencyID: Int) async throws -> Agency?
}
