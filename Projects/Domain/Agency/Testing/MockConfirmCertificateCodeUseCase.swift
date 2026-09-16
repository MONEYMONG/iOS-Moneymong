import AgencyInterface
import BaseDomain

public struct MockConfirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface {
  public init() {}
  
  public func execute(code: [String]) async throws -> Agency? { return nil }
  public func execute(code: String, agencyID: Int) async throws -> Agency? {
    return nil
  }
}
