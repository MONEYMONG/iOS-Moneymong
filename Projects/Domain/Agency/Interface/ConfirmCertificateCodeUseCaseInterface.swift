import Foundation

// 소속가입시, 초대코드가 맞는지 확인한다
public protocol ConfirmCertificateCodeUseCaseInterface {
  func execute(id: Int, code: String) async throws -> Bool
}
