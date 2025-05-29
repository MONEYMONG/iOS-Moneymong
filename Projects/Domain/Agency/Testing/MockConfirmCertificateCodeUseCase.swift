import AgencyInterface
import BaseDomain

public struct MockConfirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface {
  public init() {}
  
  public func execute(id: Int, code: [String]) async throws -> Bool { return true }
}
